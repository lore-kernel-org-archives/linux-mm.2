Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA40610D14A3
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 11:36:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36D516B0092; Mon, 30 Mar 2026 07:36:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3448F6B0095; Mon, 30 Mar 2026 07:36:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 281CD6B0096; Mon, 30 Mar 2026 07:36:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 193456B0092
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 07:36:00 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C2EF7BB98D
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:35:59 +0000 (UTC)
X-FDA: 84602525238.11.581E1CB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8EFC8140003
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:35:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=W3q54qRh;
	spf=pass (imf09.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774870557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=556GKtPgfbryfydv+tI3+PhJHtuBKVNgx90rfTV7vcs=;
	b=09zRe3zIeTIMmvcwT9G+NQs4aLheKiwRLeW//sl5R00wxYTXflHzrT/Qq4RsfbHcRHhm1S
	HWc8VdzTGaOKfD1+BdB3s9CQ+mb88Z6njamaJ6uBnxAfHZRwPBacouB0ppEtKsXvgCrFY8
	/cQc05Qyn7AU8UYz+I/teyxF5ZxbPAk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=W3q54qRh;
	spf=pass (imf09.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774870557; a=rsa-sha256;
	cv=none;
	b=zNBzY7/XtaWDBLq2ruNvKgOSYdEAjeJ6Ep0JJ+EvrQkiHEh1b/LoExUhEhMv/sYnPTbb5D
	UeGPSZoS1me5nSDT47WLI4VMHd9SIeNMRnMazOzvJ7LJ0j44irRcnYNVKrJHPgtUrELpwz
	/nl0lytgokJHY7bjSVoHLANqqj7w4Ho=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774870556;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=556GKtPgfbryfydv+tI3+PhJHtuBKVNgx90rfTV7vcs=;
	b=W3q54qRh4t/X0K+wwABXaSkVesiuN0iKBvPQCHFJNUWRq9K5PhBM2p3LZtS0EkViARIBdB
	hLEF1NNumBxYoTjy6JvA73p69U+UeVBEOKEmBrOnUlB4xtTXgltBeGuvVFbYTDwMxhTS5y
	6JYZm/CcQkoB5IaknHRcbj0L+ePAxps=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-636-BjbIIjrcMvysDtTOka6pzg-1; Mon, 30 Mar 2026 07:35:55 -0400
X-MC-Unique: BjbIIjrcMvysDtTOka6pzg-1
X-Mimecast-MFC-AGG-ID: BjbIIjrcMvysDtTOka6pzg_1774870554
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2b2454fc131so47477965ad.3
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 04:35:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774870554; x=1775475354;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=556GKtPgfbryfydv+tI3+PhJHtuBKVNgx90rfTV7vcs=;
        b=IC2fn3W/DRqfqDU2YxRvhaR/FlVRVQA92gJ8gq2i7+4jGduioctyIrTcygk6xfLJ7Q
         7bYHKddO0EfmVKdjIWxC1tIJjPOy8zY9P0sMt9fz1u7lTAiyyyktJXbIdLCJMRkPUWYW
         qLUCfIAtO9wLx/rgPJSgvoDlhTdpoa2FjSW+gychBG+k0ZiezsAKNTynJGUqFMBL2Uc0
         k+EwMWxhXGnlbFfGy8Uus3a4lWiAqTOKqnXSi1vz4hHzAW1y8EiFm+4/oi9YWv8xLo9z
         IoknWVG2n1CUw8DPo/i5fKMqhMTvCUtOB7f7AmG0BMoWdCQslrpn4vdpXdVty07EDbpe
         4dBQ==
X-Forwarded-Encrypted: i=1; AJvYcCUGVXFHHjbVONYL5usALkk2mIT5A7I5zBa1pKMkB3KlfVhXCjPIFQOYO3ZIt2aj+BeF4hdyhUDzoQ==@kvack.org
X-Gm-Message-State: AOJu0YwvbSPlDZAZhzVEW+cgL9Ey4aF5t4RFn4oGpqjsBnT5Zcaelscb
	kcjW6dLLGcGsClwfNASBbJkuNMGrCOlmFDqC1ugYkkWOJAGEBgTAx3eJx1GC3gyX2uWol/F/V2z
	Sj/OJPIN6fYoBpgJjY3RUcZivCQ9PPxjAWI8SY30RNIkFfkja+1TP
X-Gm-Gg: ATEYQzzdL36M1AN1uiDgGBWNKnGoawI14KijfpGB2RIzWGIfY0/MqAmsABhApgcEWCV
	qKOzSj0BZlBI1Ve9iSB69z/9kuBbFcya74s/ueRotCaiDvCyz9JIpjiS7nMC/on8dOyRwaURj50
	ChoeGiSkgDI2333QxBYX0qQ68dUWaY3qQC9512ZzDEwPlxXDgXalBeKu2BmaFNvn3OSD1U1LWQH
	45RATJPUyey/E8OumnzqP0k+8y/GOlINFuFBCzfnaNJkydhnCUBSxTkAaep7J8ETeIeHshrzlEg
	Dbyw91bKxW5AdKJYX3S+5i99iOKABFNrNsw0pnhCzrF7vryWxu6ro+hHBGnGnq9WMMq0Ic/xNHr
	okAhVlw4ACM6ngxYYjw==
X-Received: by 2002:a17:902:f70f:b0:2b2:4d36:7aa with SMTP id d9443c01a7336-2b24d3609ffmr53808645ad.35.1774870554455;
        Mon, 30 Mar 2026 04:35:54 -0700 (PDT)
X-Received: by 2002:a17:902:f70f:b0:2b2:4d36:7aa with SMTP id d9443c01a7336-2b24d3609ffmr53808365ad.35.1774870554017;
        Mon, 30 Mar 2026 04:35:54 -0700 (PDT)
Received: from redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2427acdb9sm80473665ad.68.2026.03.30.04.35.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 04:35:53 -0700 (PDT)
Date: Mon, 30 Mar 2026 19:35:50 +0800
From: Li Wang <liwang@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, rppt@kernel.org, ljs@kernel.org,
	Liam.Howlett@oracle.com, vbabka@kernel.org, surenb@google.com,
	mhocko@suse.com, shuah@kernel.org, aubaker@redhat.com,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3] selftests/mm: skip hugetlb_dio tests when DIO
 alignment is incompatible
Message-ID: <acpgFlG4qj646hYp@redhat.com>
References: <20260330053915.75442-1-liwang@redhat.com>
 <a5b7add7-0507-40c0-a324-81f243ffa261@kernel.org>
 <acok3JY66OcV0Qab@redhat.com>
 <acpMD8tRCJhgXHeg@redhat.com>
 <a1054c28-b574-4fcc-afe9-5e902209a22c@kernel.org>
MIME-Version: 1.0
In-Reply-To: <a1054c28-b574-4fcc-afe9-5e902209a22c@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: J32ndUnhMSFSJXshmSBgJ-1hZV9S08qrYhDXkjXbyjI_1774870554
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 8EFC8140003
X-Stat-Signature: whep7dy7qyratrnc4rrgmp9gkh5ti9jo
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774870557-809061
X-HE-Meta: U2FsdGVkX1+UEuNdgK3KdSwOEExH1wZ/r8UwbpdGwGjuvVD0CEGyjaLdronkkEXRv6dSqYjY4JEZerLBw9kwpWfmpUWqKcM7UO3CKSq4pAYjh/0Yc6xeoVBGxVstUbshPjrQv7VjQuxLt3Kn+l0dcENUXZKOjFnMIy2AGFa9hTH3It4nGjoapgrKH1lxMvlJ3UNZy4T0r27Q0yGhlq/0qwJOFH17LyOklowtGR1wFZuDmsezTJKATkvqhB5ydjTNLudxjxGorDCRFIBmYNqY9X4SmKj6YGNfWmKbtDEknBrfAXMgxJNn/F/JY1KePVoBP0y69fIrHsytrZVJRm+Dt8f0y0HyVV1bYUPNxDLO5ZUzB9Po4PUuHdu7eHXzClAWexwAIENxsOPMXPVUgUfCKkZN5T66UL/SJrDmdmt6H2zORYfUgVi2ecw6mHI2n31FmoyjAkhAywlnh14ZKGjKJdYnCBtixJJKmK1uY+jaA3UF/a1k0YeZ3mEf+1+5jCXRNU5tQOXqffZSUFlgFIUTHdjgio1TlqwodU3kyjjwV+8aCFojiRtxUQOKOkSWn2W22Kvt/XL0FYqV8jFcvQ3bsW4Van77GDWh4GmZZ1uUCc8ZZehdNUSqZHKLzNhfcg7lN5u6qYJGUZtSiB6a8n1rHyYxLS1xiycPTSidihM7BnRhfYzh2F9V4Yh443lo2RRbSHy40NQZlddagROKl0WLZfr3asvxE6tLedhwDfjVbPUPy4TTQ/sgSdxVmghunfTkxh+FpNw+hb4S9OlApicCk4nekNks7mUgwFU2FElNdn9+HpWj43dbH2Q8/ZyucxgkPKnde4kTZWroOlwTf2gi6aBv4xCFAxoB7gkFoRfT9t1gBucWqCrDNSZeNF6WyQ+uX0HHJUIL9UTEXm5ONTw47dct1bdDU0HbvlI82U2x39eSkefXpvS9ogANvgzOb+f3CM42FfVOYrLgyxmdJVC
 SdRaUNio
 2ClN/958jJNQrESn7jdSauoAIMK+GlO1MLbsTioHXS7fv/sKSG5bjPGoTxafHzxLqfu9eNLG+pk9624JFgTFYDbCEahZdyigsVHRoA+dgOJP2iMapz+OgX4fo6TAQImW1PRzwO7hAjMSHqoVTOVGFJ26zh8p2kZHBuTYdfCr1z8p1sH5PUNjOt9uoYUWNC8SEO2deE7IqqacI/vh+id7DjnsohKkcaetX5hp4f5xlGbhFbrhcTyxLG8ZNnfWDh1AQlD1Gv9MBf/3ve9456zDhYhT1g/7VCM2ILTGU6oijmaySM/FmTpNo5VrsxosrSna9/rE2Y4nyJlc1PLJHy+/m2klbGx6TsPk8n++WYlpnlwcSg8+/U6gOcPV+fyZVuQ2+e7DY0hZaY7VFPLV71t9vFPum7QRw2owgWxvJQ+iOeSTb5bB6tPyd6TB+a/8BL5zppHzqj9EQTQj2a9ylsLUnskPQe/q54Nsyl4l1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> >   int main(void)
> >   {
> >       ... 
> >       fd = open("/tmp", O_TMPFILE | O_RDWR | O_DIRECT, 0664);
> >       if (fd < 0)
> >           ksft_exit_skip("Unable to allocate file: %s\n", strerror(errno));
> >   
> >       if (get_dio_alignment(fd) < 0)
> 
> I would suggest that you query the alignment only once, and forward it
> to the test.

Sure thing, I declare a global variable 'dio_offset_align' to get the value
only once via get_dio_alignment(fd).

(sorry for not posting in the above email)

static unsigned int dio_offset_align;

static int get_dio_alignment(int fd)
{
	struct statx stx;
	int ret;

	ret = syscall(__NR_statx, fd, "", AT_EMPTY_PATH, STATX_DIOALIGN, &stx);
	if (ret < 0)
		return -1;

	if (!(stx.stx_mask & STATX_DIOALIGN) || !stx.stx_dio_offset_align)
		dio_offset_align = 1;
	else
		dio_offset_align = stx.stx_dio_offset_align;

	return 0;
}


-- 
Regards,
Li Wang


