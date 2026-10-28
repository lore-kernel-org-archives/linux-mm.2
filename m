Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8402606A333
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 14:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Y6SK1F6G
Received: by kanga.kvack.org (Postfix)
	id 10CAB6B05B2; Wed, 28 Oct 2026 10:38:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BDE06B05B3; Wed, 28 Oct 2026 10:38:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F158D6B05B4; Wed, 28 Oct 2026 10:38:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C9C086B05B2
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:38:06 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 46D4DC0CA2
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:38:06 +0000 (UTC)
X-FDA: 85372289772.30.5B05F6A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1A3A4C0005
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:38:03 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Y6SK1F6G;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793198284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SsgeWLG4dI0l0/bC6ar9wPtwyPpf6L7PqvCPXj7gOQE=;
	b=ssTS5ETL5of+ln4XVAdmQKrwP6GdkYTIkJWeHbgs3xMc08+fr5BQ8Qz6jp6MmvS9pU3b/S
	iNOonixhIaSg0TIiiT0b/ySwwQ8FsRYKZ4UfFm8lObP+pWFUUbQG051m50EKX4U0Azl5Kk
	h1uD5PbNGrXSiatJfDgaI8erAydLqrY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Y6SK1F6G;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793198284;
	b=cb9CpCLSiWggrB6sIgsm4eRzP11Q7JQIJt1jDzcl8CQr0vM1Y36iSJnMONFR28t0JJsY6B
	H2zSCVEoNOukTFHvoxPetO1aaCPb/NhkOM1cepYoCbMqTDFxJNuk33VBSoxnVYVYKKS7vy
	6Czop7N5kmdUN/DjTqgAyZ/CyUabv7o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793198283;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SsgeWLG4dI0l0/bC6ar9wPtwyPpf6L7PqvCPXj7gOQE=;
	b=Y6SK1F6GZJnWwamsHB0Pp/GAIBenbfMFZTnI0vbxjc/F2zxb7PlH0ef5oK+ftu7VQqBGsV
	dci7Sr1yY0QtAo2gUW6Yn5fhtES2N36gOsgoPAVM/l559tDs1ab7VxOZdjxoeAOnzWR5S0
	LevPmM2e43/J0d8xw+20e+aNAd/OaX0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-133-QF4qfS1LM5m0tpuRNg4TWg-1; Wed,
 28 Oct 2026 10:37:57 -0400
X-MC-Unique: QF4qfS1LM5m0tpuRNg4TWg-1
X-Mimecast-MFC-AGG-ID: QF4qfS1LM5m0tpuRNg4TWg_1793198276
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 196681955F7B;
	Wed, 28 Oct 2026 14:37:56 +0000 (UTC)
Received: from onestero-thinkpadp1gen7.tpbc.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id CD3A319560AB;
	Wed, 28 Oct 2026 14:37:53 +0000 (UTC)
Received: by onestero-thinkpadp1gen7.tpbc.csb (nbSMTP-1.00) for uid 13628
	oleg@redhat.com; Wed, 28 Oct 2026 15:37:55 +0100 (CET)
Date: Wed, 28 Oct 2026 15:37:52 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Mani Tofigh via B4 Relay <devnull+mt4022.columbia.edu@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, tz2294@columbia.edu,
	Mani Tofigh <mt4022@columbia.edu>
Subject: Re: [PATCH] exit: use READ_ONCE() to read mm->owner
Message-ID: <auIIwLWa3MLWCd6q@redhat.com>
References: <20261027-kcsan-exit-v1-1-7c0429a29bc0@columbia.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20261027-kcsan-exit-v1-1-7c0429a29bc0@columbia.edu>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: 3nwNzYopAPv45V7Jj1GJKP1yYV5jMxrJecL8LdptKa4_1793198276
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 1A3A4C0005
X-Stat-Signature: pg6ftfhnjq3j8cr89tz7bsopxx16kyti
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793198283-809623
X-HE-Meta: U2FsdGVkX18cyfJ81tmRpyhTYW0sh8mXkldufUlGQA0xQ/Yug+8T51qBaF851FWqhmOm0VSdGVDic+YkIjCG5o7eLqzraL6MV62tbq22vL7TxcbWqM1P6F5eYEFWhSxUMiroziF8M+7r56RjRXNC5A+4UbqCRkkYf3NQcoA//53CkIyNkLObbBgnvu2jK6l4/rObirLj28P8J4ku+eLTunoL0YMiG1TyIcVBE+XTmdpqqlpwCzq6wqqyqeM0G3Nazq4JJODZgVDZFJ9z4oJG0MgoH1doVuoakGQ6qhQI0r0GEfZMouHO8HMagtro/saQgSivverugdjyO3FvloT9EO169WBFWrSU7Wf5wS6RLKlBZ9eFiNxSOAjwB7kguJ/3vPD+vFV2BTePFmSCpEIo6/FYIw6TOvyV7NPzbhSoTa077SzBk1qqxxzTiSKVclcPmMOv2OMLMKDBQnLlhy8XuUNJWullZx2YQMNXWtrsVi7UNx6tTKqZ4vlX9qH+O3BNUSiN14IT278npSxwAw+WuPBeE0FxKShONSfuJRSFydcXGoE8nyBeDzbmW5hCbdwAsVXDR8CUVupHCZFKWzWlEE63eaLWyWBuEbo030VwEKZWJ7PP6HQFJWYf0x7Q/aeIQ2pvxm70E1f24hlk60PybKMs3ky4muVcb2Uf0ZtOxXgOlIfB00Fe+2iKsZuA/FMhyDSysjDcx86w5YMYA8lpJbRjs5n6JUMdrBOC96AR/zkm2f7IbeCw0HRmC+NZR0UR6CBkjJXzCKHxlDLpbbHahdMtDr4/fsXbx5WBFMK3fynD2zLv4GMz8a+2SzMGdkWno9wYgu6x5FC9kfMwhCmg8xZT64TF/xTf9uZk97wGHgcTpCDUgzeF+t9gDEQUvNB26qzRNs8rohNw+HHIzH4iGHe1r+1PWq6GRG/GhEAucUxPqbQeJ/kDfSxYM48nfkhqigXgvGrdGqGrpzTBX8D
 ynKMELYj
 euiZfQSPH2BPBsQ23NOfU/k2MAPpFqimr8ljqiZ3L1rmpdDoOc3vt9az1SmY7yLUizhQTYZdKcNAIKQqC9jKeY4RpucQY8gRIOTR4VqxCM4RpBA9LxR8hLgW0W+hZ6RIpkoZg3tS/blU4pzTibmE381KRrGVo+f+dEVC6HCebkZRZtKF1BA8lM6b1d/0KkugixYBbQK1Wq3wY47ajdd3FCTIUYhBw+y3o41NYPRXC1bbQZKO4CHL8HRSdNhOCZAOC1rGB/8pg+MTqnSTgscwVabNruNyVKdBTiXYeLVeLLPsT2wwWto21QCFeN22L01kyBX5GlFT3BPLm3arWEMY72q8DQ7fXJiOwgUMYcsqIcLkGMXkxKJvTMqT7PmfIY4201E+ZE82wmbARmaROj4sR9suiAS3GGl4frW0DQrnpxgGPebPI57xDUhAJvEVC88yKdqnlED98EftUf7GRPRL7/YlT6G6M/zIdId+6v8BXsWWaLDQHbXDJWceeze1H4XzKHvRlpP+3PSL3XleiZF2kd7FvWSGdSyXGO3oAMJEMUHSwdPA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27, Mani Tofigh via B4 Relay wrote:
>
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -494,7 +494,7 @@ void mm_update_next_owner(struct mm_struct *mm)
>  	 * If the exiting or execing task is not the owner, it's
>  	 * someone else's problem.
>  	 */
> -	if (mm->owner != p)
> +	if (READ_ONCE(mm->owner) != p)

Acked-by: Oleg Nesterov <oleg@redhat.com>


