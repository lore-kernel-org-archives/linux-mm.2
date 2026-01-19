Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3301CD29C2E
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 14:26:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87D2F6B01F5; Mon, 19 Jan 2026 09:26:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83D976B01F7; Mon, 19 Jan 2026 09:26:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 774B66B01F8; Mon, 19 Jan 2026 09:26:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 623536B01F5
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 09:26:47 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2ABD8B58F5
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 14:26:47 +0000 (UTC)
X-FDA: 84348939654.24.3D49704
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6806AC0007
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 14:26:45 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DmFJt6Mw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768832805; a=rsa-sha256;
	cv=none;
	b=TRWtmoQL+qptj3aQa8w2Rl/GjG1/XKey3MiZjKWX6XrbRTg2imRs9XBbfwBXB6NYqbH8ds
	fhqnXAvwmesS8uchNDqd/3S3zeF8FoX7PsLntScblCrTLxThLXPGqcd9YB0rkWfVWFY/e6
	Te5XXVhWa48g9QY6uTF3jxUzAkxp7KI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DmFJt6Mw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768832805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mVNWDAs0/xcF9uFydp8tYiJlwebm3iNXB8qxfHM8cNI=;
	b=LVqAqNWOVYE59IWU3bofR1VJFFvUNg36NilKcUMk0mgngM6s6GJATKJvVr16rhNi4C7ToA
	MoZbtqPZN3A2t2Qt3QitShD6Czenu8cxznELHDo8w8eprbi85BGmDXY6/KcpHC/z+VpsBn
	iSBr7oIZe3rA8zxoEQA4aBqz0zKULk4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 30DDF43BFA;
	Mon, 19 Jan 2026 14:26:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4941C19424;
	Mon, 19 Jan 2026 14:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768832804;
	bh=zYgPbUIvOI/eIYcLAUkaAfmyJoWuvHhnUe5EkIKG3qQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DmFJt6Mw/5KVucLHrqBHkKImBW4D9anZGrDzR7DQ0z+TfTHQjB/JLG3sij3qK0FDT
	 N9dTP1ieNYwddPogZcPsYykDCnziU7O/cKnIVud/yiOubFUoQVnYPmQJtItcrcPVZ2
	 P/NPA9bzvx5f1C5FnYmICbzEMk48qXwuD/JnZBKCqAtaL4Dc6+EE8G12Ghjif00rxL
	 jXxZBvWZ2LCJCPHmFOqiXxiUTtzP8JNcqMbjfILHZAVkRntiN9fvfNRetSN78bClse
	 HGsElR3adIdLZlThgAqzTg9R+F7H6RkuzWzJAZjLXe5ooCaCtj3cGfsNTp0zmSikOx
	 95itlDDyxK4LQ==
Date: Mon, 19 Jan 2026 15:26:39 +0100
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-nvme@lists.infradead.org, bpf@vger.kernel.org
Cc: lsf-pc@lists.linux-foundation.org, linux-kernel@vger.kernel.org, 
	lwn@lwn.net
Subject: Re: LSF/MM/BPF: 2026: Call for Proposals
Message-ID: <20260119-bagger-desaster-e11c27458c49@brauner>
References: <20260110-lsfmm-2026-cfp-ae970765d60e@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260110-lsfmm-2026-cfp-ae970765d60e@brauner>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6806AC0007
X-Stat-Signature: 68i3emty771nyx8sshkg1q31416r7bk7
X-Rspam-User: 
X-HE-Tag: 1768832805-300107
X-HE-Meta: U2FsdGVkX19yemvyk1ByVmyd6GLw9b8KDjSJANayanGNRK0pjecOzZ22O2jwl/4ELeWZAMOnRLZqUXMxbrZLXiI2r9WOI6epNF9geSGJsJCt4cXoILyHJ1/dANSVrdRcDQ8ho3AV1W+RunmdPDYPMxgibGw5FdgZy0UiEillDd+WhxUJhJXzD2sejq5g8rLn+Bk5g14vJNFyePsH87BRg3wXbK00U7lnvpr2/a8sd3rUyVn9uAX+YRHeEvqziCKeRMb9DrU5vmNr/Sjqi6h0IVrACWvFH8DWSl6rxwtgaP5gqKXjLAop+RvY/QXsxrBGcxa0Meizx1ELkWpdHoD9mOQLMT1gGidEsXzrG5eID7VT+cbVvlq9Vf40wiyAhbSwLT6Ka1xvdw1tCJu2pLfT6VrpYPY/FqJkVxDv9b9Q+9bXj914kTBZUYdDrBr/S1gBgukY/jhZswJW8bAPuZStvTuYoYnHNssg87AQJbqGWNRQO+nlVtrb3Lsy7iqBhINGGmhah2q0mGoN8pZ/tiYX8r4GJgt3t0yQTD6l/OoEGzNyGRGeu7qX+wNS6wZ+xqQT238MVqKZf0NNctD1RWDZyrH3Xirp5zEPIQqhAAm+InlLmJgOt1WAk8IkNsfPBAEPej7uumFZXb3amevtEzYESoQDbQWzm6lzAHrr/uIr+3SZdaI4SXWTfl3zsDgbe4GFjboci8bwjpDQx4kqJuC6vivlr4XAkXzAa/+6QKtzx00AlUfdCqC9rNXD7Z/FeOlI1viVvzfqShJxkMXctWwH0NQ2jUKu1aDAI2/XlltWICcTj3hxuGLf7Qg5cHx9/R9SY4pfIQvpeoDuASm6TkGF5mgTB/bYx+VGZyjvo66gljXJ3sxwZ8w5SQ0e4oAXiHUbPFqQEwb25IvLC+Zf+TW3xlafGCnr/sFm/HMf1QYW0pCiZy+nq/vosq2VnG9JUaURJpdSIt9dzCw9uRPlRMz
 FQFJExmS
 ISCBk6JYdKFb8n3/Aa05TGugwPFG+ZpFXSYlOqi0cG+WQk1NBx4BBPPemUTVN4C+uT2U6uKujkDS+p/0rLfjzNi0KpZjstVpfea6ROzdRzYGAF1zetDPYslpJd5pHd+iLxbHaN8/7gKwTOHT3BRPHel4oKNhXOc6pOhECmH2xMeH/zKE9KGMnunJa653ePIJ7j9+Ypp7tp5x/Ka4dG47gUJBpQsRYfkcf3Y+FYmDiyEzQ3/QvzCmYkfmY4HlwLRn0ucE+X2lTr8Kp40ncx5rzTXDjxIoalG+3sEDYWxFtW7/roEbCHKwVGCY5CErQ2J+b0etndlmk0/kVKHI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> (1) Fill out the following Google form to request attendance and
>     suggest any topics for discussion:
> 
>           https://forms.gle/hUgiEksr8CA1migCA
> 
>     If advance notice is required for visa applications, please point
>     that out in your proposal or request to attend, and submit the topic
>     as soon as possible.

Hey everyone,

This is a reminder to put in your invitation request for LSF/MM/BPF 2026!

The sooner you do this the easier it is for us to plan and the less time
we have to spend hunting down missing attendees just weeks prior to the
event. Unless you're really hankering for the special-snowflake
experience please do your part and get in your invitation request.

Please also don't forget to pester^wask^wremind your respective
organizations to consider sponsoring LSF/MM/BPF 2026.

Thanks!
Christian

