Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2EBEF532C1
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 00:18:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E97626B00AE; Mon, 23 Mar 2026 20:18:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6EE66B00B0; Mon, 23 Mar 2026 20:18:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAC5B6B00B3; Mon, 23 Mar 2026 20:18:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CC5AB6B00AE
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 20:18:51 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 695A48D355
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 00:18:51 +0000 (UTC)
X-FDA: 84579046062.06.06525B9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7CF30180006
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 00:18:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dWnHBod7;
	spf=pass (imf16.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774311529; a=rsa-sha256;
	cv=none;
	b=nufExSZznJJQxoUMp3lHKyABk1e/Q21LHSf/ZmtGzXn6v1eh4WPVHpO3fYFdvFardc6vuo
	SaqDjDRu6ucjI5qX+AiQwCKAfvn1JEPoLAg8LlkfNCavuMdc4d7TFV3kcBF37mJB9Dm70u
	DLf4VTLIOssMZnTI621F/eu2gqHJ8lk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774311529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vXzLmy9yBL+MosyDIkq8eObiDBonWwPvsZwMJQOiiLk=;
	b=wpJFT/GZ4fOVt8MfpCbO6ZHGF7/8u60XnfM62sU+vI6aFpKJpP+FTaUtSeoNknGWIJ3hBA
	238l+8dCdApJBtAJkU1U4XqSHsV2diKBSWL4l3kAWV5EtNDkx3ZnijaXEBdI9MkTLQRYLX
	OyM9W2vcz7VvMwY0gmzNe0pvAxanepA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dWnHBod7;
	spf=pass (imf16.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774311528;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vXzLmy9yBL+MosyDIkq8eObiDBonWwPvsZwMJQOiiLk=;
	b=dWnHBod7kcsix+tqXG3QQpceFBJ+m8IOb8fLo9J7n1SnrG1B9Bhdk6da4F6ilCE9F/p7IJ
	ON+Tocgd38zR8QTnLE8+ivvjxH2Fk4GaJCw+Ja1CKBKeoYR0R0/7irZXI+tOsd4ZwVuYpV
	AyL0n++0c/yVePxKxWEazjNT3K3jOS4=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-482-wdIQRatmOOyip77YOmUoFg-1; Mon,
 23 Mar 2026 20:18:43 -0400
X-MC-Unique: wdIQRatmOOyip77YOmUoFg-1
X-Mimecast-MFC-AGG-ID: wdIQRatmOOyip77YOmUoFg_1774311520
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DEF5F19560AA;
	Tue, 24 Mar 2026 00:18:39 +0000 (UTC)
Received: from gmail.com (unknown [10.72.112.53])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6DF5419560AB;
	Tue, 24 Mar 2026 00:18:30 +0000 (UTC)
Date: Tue, 24 Mar 2026 08:18:24 +0800
From: Chunyu Hu <chuhu@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: david@kernel.org, shuah@kernel.org, linux-mm@kvack.org, ljs@kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev
Subject: Re: [PATCH v5 4/6] selftests/mm/vm_util: robust write_file()
Message-ID: <acHYUE1rn5TYyxgR@gmail.com>
References: <20260323151753.2576137-1-chuhu@redhat.com>
 <20260323151753.2576137-5-chuhu@redhat.com>
 <20260323153941.289938dd9ced4dbb76ca7804@linux-foundation.org>
MIME-Version: 1.0
In-Reply-To: <20260323153941.289938dd9ced4dbb76ca7804@linux-foundation.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: 25T50MlElR3QL0pI4G6YPryM0rqMGlKrlxXKaDnppHg_1774311520
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7CF30180006
X-Stat-Signature: ihjfxfheddsh9ow1u9bydk3fxeafucij
X-HE-Tag: 1774311529-338589
X-HE-Meta: U2FsdGVkX19MHEyirrQJnHAZcnQTQacEp83UBzWxd55WjM2SfWmMkCHuXr/x8A2fY4ugojiF8/LBvdGw1SRi4QZQvIP8MMYY2XTbpp4Pi4f13NAhyu7J38qOQfU7Z08swXx00GwGAGYL/19VvL+RY0eHDWEchHg0wMuWUbDvRajgmib9NHYuwD2fAA//d8gLktdGmQnv3qT+0v7n+egWbsUZ0SlLR6krgxugS0D+Ro7oSwD9opnuPj4OwHqhwSVf0N3z4UVxOf0qhfj6mxSVSCgr+QksH7hVupb/X3znTqzScxjmoIH/oS+kRghxD/OBhJrTdabLCbzgNKQPfWxh8ICxp5zDtViJva8nljNuRIvNmSTDK+ARLFShA5a4GCx3lbycpDtfK+qsqSZb1rhmWI8mkbNuEpHxJ0g+8G3PWVbLIW9rXQXGpqcChTa9JNLMPB4DDZzkSnufURXJJETrqn7crthfcLrx7v3j/7HYqjEcihOgFmZgpofypM1zQfFTDsoXVW3LhmWWRx1E9FaD1MuxjLGcU07qsoVwhXbTkJ7Peq/h7CbGr/g86BDZbTDFMIURLKdLCfNaQOjhnYzFq/wWctr2tsjPWW9NcwKTgtsHSSqfAzxQi9P308Cv5jNLqoWrhpLstHptcna3OkmrMwXjQBsERp8yeckaZR7vdimiWYYVdMyi80FlLuKVNJ95s0PyjdRXDpOEf7WlcN6LRQ09thwyhS8fEh5teeuYt6HQt9arXR19z7ohK2KjZ3QDeTYkRpmnDA/WGhyH1C7a61++E5zOSdm7leC97Oa/bmioPRoKBDzWE+1fBUzJrKE2g3aSTK9xdUgMch1LMgD7zUqpLSK9g2liwNMoQvR7EKRqcRBgqjuuAci9tkCPeBl58JH7URPk2aCx/HDqG/G+uWOLMvQt+GT42vIgzJk7tnHtSH+wLho3KzYnXYbm2/p5pRh5/ME0Yy5jFsNHJMW
 GUpbZpPB
 zWucdLfDJ3KOElq+R0qju3RN1cAh6kN8dWKKK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 03:39:41PM -0700, Andrew Morton wrote:
> On Mon, 23 Mar 2026 23:17:51 +0800 Chunyu Hu <chuhu@redhat.com> wrote:
> 
> > Add two more checks for buflen and numwritten. The buflen should be at
> > least one, otherwise the 'buflen - 1' could underflow and cause trouble.
> > The numwritten should be equal to 'buflen - 1'. The test will exit if
> > any of these conditions aren't met.
> > 
> > Additionally, add more print information when a write failure occurs or
> > a truncated write happens, providing clearer diagnostics.
> > 
> > ...
> >
> > --- a/tools/testing/selftests/mm/vm_util.c
> > +++ b/tools/testing/selftests/mm/vm_util.c
> > @@ -769,6 +769,8 @@ void write_file(const char *path, const char *buf, size_t buflen)
> >  {
> >  	int fd;
> >  	ssize_t numwritten;
> > +	if (buflen < 1)
> > +		ksft_exit_fail_msg("Incorrect buffer len: %zu\n", buflen);
> >  
> >  	fd = open(path, O_WRONLY);
> >  	if (fd == -1)
> > @@ -777,5 +779,9 @@ void write_file(const char *path, const char *buf, size_t buflen)
> >  	numwritten = write(fd, buf, buflen - 1);
> >  	close(fd);
> >  	if (numwritten < 1)
> > -		ksft_exit_fail_msg("Write failed\n");
> > +		ksft_exit_fail_msg("%s write(%s) failed: %s\n", path, buf,
> > +				strerror(errno));
> 
> AI review
> (https://sashiko.dev/#/patchset/20260323151753.2576137-1-chuhu@redhat.com)
> points out that `errno' was overwritten by the close().  Maybe.  Or
> maybe a successful close() leaves errno alone, dunno.

I'll address this errno part by adding a save and restore before/after
the close().

> 
> Apart from that the comments appear fairly minor.  Please lmk if you
> think we should proceed as-is.

For the other two minor questions about buflen == 1 and non-null
buffer, user should know a string buffer need to be '\0' ended. 
Those are really minor, we can leave as it is. 


AI's comment on patch 5 should be other topic, and minor. Let's 
leave as it it.

> 
> (I'm really trying to slow things down now - we have a *lot* of
> material and a few weeks of consolidation is needed.  But selftests/
> tend to get a pass, for obvious reasons)
> 


