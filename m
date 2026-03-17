Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA9BBFD877E
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 14:27:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4D9C6B008A; Tue, 17 Mar 2026 10:27:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFE5D6B008C; Tue, 17 Mar 2026 10:27:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C13B96B0092; Tue, 17 Mar 2026 10:27:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B05096B008A
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 10:27:42 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 17D671C1CF
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:27:42 +0000 (UTC)
X-FDA: 84555783564.19.F92054D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 842B5C0013
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:27:40 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=REgn+xp9;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773757660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iK5BF1BC3J+te+7cyY5pPabEOJ+SARfI0E6prDidu7I=;
	b=Vj46gHf1gE+lSt1UnV1FBok/P1m67qFdmKIIhI2OPThz56ZPk647cJAZ75stFb4SJ2mvgz
	OUFruRmKu3fbalIOpjc3qEHXCxuIAEcnu33m9VDNI7MYYOeElGsmhOt9b96uEcBV2klBVL
	HGFuC0u2cj5AAK7u6H+m9tOkWOEG1D4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=REgn+xp9;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773757660; a=rsa-sha256;
	cv=none;
	b=cdVPu2jbRroylK4rfQARi6pJMBnMdW92rjvRqZvXo1PNVAHnEbwQLisrGOu8qWy20OBRgK
	oZIn+aSHC4W6rCbageHBjAFXqQH5qIPwyPhz9PuWdN/2cpix9AtA16A1KVVEKYdQdS+cqz
	jQc8IH2wPfhDopeMgtjznrw/vA06whM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CDF1460128;
	Tue, 17 Mar 2026 14:27:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D8E1C4CEF7;
	Tue, 17 Mar 2026 14:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773757659;
	bh=XOl6Bu+EEA4KkABLbtRPgOFSYl2RSYASfhO2RLLNbis=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=REgn+xp93sGdMEzMbVACcol4tJ5zgJfBrmh+dm04pZUFiu1Wy/uJm5ZAWUQD5/D1V
	 1vJ9Lys57KR8+WLv9QJpJoE0MmxsitHxDJ0Uh5qJjQ91nhhCfhz2f0i4bYf26ofcwp
	 zhjN+skWVRONSWhw+VUfvM+OOLEWh9zyGrdINjeCbik8zqJPusZ7KcDVeMfzJWqplq
	 Ysgy2K0YZg4619juY6eFGB3Z6TW6ArKoou0Y6DQVw5PQE3kSbLxicmy5nrH6vGK6/n
	 9t8g7rhX5+ctRXQNxRoGYDSIGYPCczcBJc7HuqcE18WUwvE006ivNC+emY2OC8JSLV
	 pOncUB/cD3uvA==
Date: Tue, 17 Mar 2026 15:27:32 +0100
From: Christian Brauner <brauner@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, 
	Shuah Khan <shuah@kernel.org>, Kees Cook <kees@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Jan Kara <jack@suse.cz>, Oleg Nesterov <oleg@redhat.com>, 
	Aleksa Sarai <cyphar@cyphar.com>, Andrei Vagin <avagin@google.com>, Kirill Tkhai <tkhai@ya.ru>, 
	Alexander Mikhalitsyn <alexander@mihalicyn.com>, Adrian Reber <areber@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v5 0/4] pid_namespace: make init creation more flexible
Message-ID: <20260317-rohkost-gehorchen-75eeda82a4a5@brauner>
References: <20260313111014.2068913-1-ptikhomirov@virtuozzo.com>
 <20260314153203.cfae7d3f420d2da050870f4d@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260314153203.cfae7d3f420d2da050870f4d@linux-foundation.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 842B5C0013
X-Stat-Signature: 9p1maq38amrurm5kxdsj33z6shsegnm9
X-Rspam-User: 
X-HE-Tag: 1773757660-915555
X-HE-Meta: U2FsdGVkX1/hlDpE6gLmem/r8YM30gd2OMk2avncw0VkLqBuIokO4R8ysLKtERnZ7/moGko5bOxCaeBRq/SyJshc73MKrn5suB+e5iRDDWKVdAuzt+wQewL4eE9Gor2JbKLpWB8S6Rf+lMsvhWWXKHeXesef9TlCZLu6acmsZpB6Icju5gLaY6VwxeFdbjMM3lcG92CphCDQntyE4kTlhtzCP7ZWZa7x5l3+I6MsNMq+mJTAD5F3KFZEsmFBh3Reo9pfpWaiN6nfEzKrbYebtLixJDa7oSb2ACo4veWCL3v00vnHEav8JBuSp9Vp18HNm76TT8ozTzDrrSp4TgaUo0bmuGDf66+rnHxyMRLM3AH9HNOcl/FNXJkArZbe9hjKfnviivGKcfBVQQm32HLJJw8qT+iypzptjytiuhiRT0PyPXebQndYukdvWjhs9FvINU7qt7u/sqE1g2u9NkocD73j8+LyHElJT+DecLSf+wlZp6l8kyWWobtt5TRdPFaZKxeaNs4d8HRSSPEr0aMuLpU1kgdzuRqNHiZsYRrDgzCCeDgwhpsqNkpeXx6t/FQDl1XRFtG2P00XMgkWXlpfXfVTsRBQV7hgZIYlJIDLKy/Bbww+DkRMytUU6Xtzcbuzr66qi2wB80JUmEVFxUKWb4ubA0qn0YrqQWGQSLP5ozaS7O5vewhPAT/ZB87nA15tnrwMA5CnbjLuPooD1EBHw6LIPiFPGV9Kxi4YZg69ks4XyZU8NjJMHAxzFMctaDu/S1rJIfTgfKral/IzogDb3riEnjroTtgFPeLIJab0uZk552yaNIZHdOZmGbhO1tDvwo4daRDTn+k2eynJ9niJlDaGd6OFhzrzrEwhUyA3qkHDL6orV7mFybyB7/SIAV4RouBykgBYRfjfJDYC3vSgzWZqPby5fe6eooMmpVKwoim4b29ruVw6rMeGpwU6kCC1xbO/wTXUEGSonRBf8wW
 ahQ9yMdh
 2oVo14E0j5SIhLaU3ocepLTc42fbibwH9v+usKnp95HXJkWMhnwHy2Ahj/a/jBjUCAxis8v/7mxrnc3NB3TKWj9rI12UkHq6n8lkpWJm5VaeBasFxMhblrkdpKo0ye+vqqnuauYE9ii5ZpN6Jio9GYf7eAt0Bv9+YgSei6JKwHRaBl1yROcJJ3YXTsSImakRfL5u4rmIeu4Mw1ANU7s74wlbPeoplAbhIoNJC99nEpBDB1kGj0Bf03HvLo823bAsXePR9NiWw9K46AEzqj6igm3jnk0oFk716N10Ya0kgSq2B58FcuRwJa2aHQVMU137aDuKPveNSZDe32UwhoTK6oJIZFHB96u3emfcqtxF1SBCMuHY/wAyljwrZHX2qSUowp6xdbECUkuNa2USIOvGqO52JI7KBbnLT3TsHVPE+NMpoBqKpBmYAbSzEMcuCo0gLBKdylUChS9xMVXT75FZYIi49e36ovgGERrFTOJi30/Zr5Ls=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 14, 2026 at 03:32:03PM -0700, Andrew Morton wrote:
> On Fri, 13 Mar 2026 12:09:38 +0100 Pavel Tikhomirov <ptikhomirov@virtuozzo.com> wrote:
> 
> > To: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Christian Brauner <brauner@kernel.org>,
> 
> Actually Christian is much more pid_namespacey than am I.
> 
> Christian, a MAINTAINERS record would be helpful?

Yeah, sure. I can add one.

