Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79DC3C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 13:33:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B6676B06E6; Mon, 17 Aug 2026 09:33:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38E176B0827; Mon, 17 Aug 2026 09:33:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A4ED6B0828; Mon, 17 Aug 2026 09:33:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E8F936B06E6
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 09:33:15 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 540FB1206E4
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 13:33:15 +0000 (UTC)
X-FDA: 85110852750.01.9DDB623
Received: from mta0.migadu.com (out-46.mta0.migadu.com [91.218.175.46])
	by imf10.hostedemail.com (Postfix) with ESMTP id 72F35C0007
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 13:33:12 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GeGFjpj5;
	spf=pass (imf10.hostedemail.com: domain of pankaj.raghav@linux.dev designates 91.218.175.46 as permitted sender) smtp.mailfrom=pankaj.raghav@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786973593;
	b=gQ3Y1ZxzMJFxexP2zh+84YTI3Gd9OMGs2gaE6q5Zf5bXm/aPC6mqNz87PBjolHrMBlYOO/
	Ksbi/xnXJCrfnfSnsZM2AuSZCBcjAgqM94GrAy+Zh9baKsV4yAgwDY1L95ZOpcVkDRCzbq
	Hu0RlcTHjYyCmgneBgZx0l+aWfUylDE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GeGFjpj5;
	spf=pass (imf10.hostedemail.com: domain of pankaj.raghav@linux.dev designates 91.218.175.46 as permitted sender) smtp.mailfrom=pankaj.raghav@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786973593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O/SOkBpfPQHEf5YCPyjlmuFG3PwH4MqCSYnnbvKJC+0=;
	b=HCZeUaJU01zwjFxYM7ih2y9Cx5llpJ2lamtEk3ThqKvuLG7AlPwCdLJ0Q9ul9VOFltVucO
	XKCbm9bzIhz3x4Y6+pN6Eg+1NTm/u6fDEGLsBxzqKT4EvJc0GZvanxK0CAjgugf2V5nYak
	R0Bq6iOZpLnAUosJ0Kxus3i7GUVEz7s=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=qDGaSGd8u93TvDMngq9Ccz8H6NOTNAvsQwpmKdm0k/A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786973590; v=1; x=1787578390;
 b=GeGFjpj5MDSsuTWe7+LerZ64ouJxtM7Yks9OqjS79136RFU6OUFoTPPNZzXzZ0UGA3vUP3eT
 8ToysIyKmBTYvxFNNhFHZZTA2CFlZjbeDq0d7cYaqqPlfSHxE3Fg4ukr1m86AKGUuP1o7YqLO/D
 Q2TI0PNV3MPSEVmY5fUxK4n8=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (195.100.225.50)
	by smtp.migadu.com with ESMTPS id b5cc297c925db0cd;
	Mon, 17 Aug 2026 13:33:10 +0000
X-Migadu-Flow: FLOW_OUT
Date: Mon, 17 Aug 2026 15:33:06 +0200
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
	"Darrick J . Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Christoph Hellwig <hch@lst.de>, 
	Dave Chinner <dchinner@redhat.com>, Daniel Gomez <da.gomez@kernel.org>, Theodore Tso <tytso@mit.edu>, 
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v3 09/11] xfs: Implement RWF_NOSERIAL to parallelize
 RWF_WRITETHROUGH writes
Message-ID: <aoMMIfyEuuaDFpMh@quentin>
References: <cover.1785908600.git.ojaswin@linux.ibm.com>
 <945bb8c88a121580cb07d0311c6742a2584ea6b2.1785908600.git.ojaswin@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <945bb8c88a121580cb07d0311c6742a2584ea6b2.1785908600.git.ojaswin@linux.ibm.com>
X-Rspamd-Queue-Id: 72F35C0007
X-Rspam-User: 
X-Stat-Signature: wcon7nkuu9ackpbhbg8epth8nk7zzmn7
X-Rspamd-Server: rspam06
X-HE-Tag: 1786973592-43203
X-HE-Meta: U2FsdGVkX19ZamaYeypLTMVHy5lNWoOAKT3AiVvpnmtn7DHZoeHGS8E3IMXCF7eTh6ykOH+HePwL+Prk6CljL46QyW8UaapNr8EBOpEeBuJfPfufyJRja7eHf8Xrr8psoQOUjn/VSgsWfYjtPr/N2vn44z9YAvr7arExJGiEe5PDiopAI8AUjULIt9iBFWXR7WATPbDAviq0kqzt7/iWv1zLOW+X3nQENjADiU7BPu52fNmC08dw7LLi8IHcANY6HZpaSio2NKgCehXzGjev9cXp9K8DQL/2OTWxNRaKCwL8M/8koYJUBupy3t7R+XifYqiwb72caHkNuwjEdJk3kXOssSRr4PIuf3JFZWkupG9xiroNqHvZXrC4jsW0gnX1x8Vlm2hIJvzF+KTuNTr0EsaHdUdVtC3UG3c0a/PiDdNF4FD1xOsdl0VdZkHG/KgefZ0kQ6rYDZalBrGDophi78uHCPduKttiVp+CQNaomyGEH8UkLTt7EBWQ+WQcVyzPeSHkVOMVUFQHs5mXd3J0Sw1em/qUyY7SsWHkBPBmak+KlK726Ogk7K/m8clwVSruzhxnCW3a107H7mmOn35lni8+1g4vtNlVfHrKU4dE7+tO+G144sZHiVC5TQinp/s8WGlxeyhyvlIblVxr2+sL31RYUzm7y1eHRYNVxEkMjQ9K949eJXGrM6glyTJnM/mvcDFf6K7hjCOfl09L83qEOzEExqIrsKo5mLIIRQrzOZ2sKd7rM+W1ZXR5SH3n5seznhtGzNDxHhNhya3CD6bLChZXBXM+UJRVOHZICrED6BBXn6lObktwgY0d4pnmcd9IbS0AFdwJO39w68GxWvU8qmQ9h5jGwt142SGhyn+IFbPj+/gH6MR05b29mVL8pqE2yTL5nfRr23hEH3oNwPnLM37cvlk7BTLWWCbI1pyquyF+VpAEyUp3AyC83G1h9IdZ/hWREI7P8BeGOumkVBb
 xcowtM8q
 e//7LakDO01FdUcRGD368LYQ+l0J0ZB1cT6xFV523U6yqjiGki05kz4YfWcoRWYDlQeUllhmKUf8KstrGTG6uGjVLh5EkMwLc58Bak8tfLHA0elKhPfc99rR2q+qWb5sIkqfb8xjWaLVzvvuovfo96JSdx3y1k9HU3xl+qM+ZwlLfbsm4LBxK2LaKd94uHOvCl5K+D8GGImoNv9+QFSgMBoSdFdnjJDxh8KOWxc5iiG5IKyTU2/p2h7rItTY0Agk6UNCGWu+Bykf/p7eSlm/ydiqazjYwLKXD4l148ipiMnLcFwJmg9BN8yKxhey3ezU8YK3OigySfQpF5FRzVsIfFQxCID25hfmhYWZOHwn8eowx4CWQ6wZesD3WiZgUbKA9+8zM78jnnXsZdUeAtT4D/ZHbWKlVP9kRIZ6D2gOtVczculAQNY8vlZj67Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>  	}
>  
> +	/*
> +	 * Writethrough implies non-serial writes ie writes can go
> +	 * parallelly.
> +	 */
> +	if (flags & RWF_WRITETHROUGH)
> +		kiocb_flags |= IOCB_NOSERIAL;
> +

From a user perspective, shouldn't this be an explicit user flag instead
of implicitly enabling for all RWF_WRITETHROUGH?

Power users who would want performance over POSIX compliance can enable
this but it should not be the other way around IMO.

--
Pankaj

