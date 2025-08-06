Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81B32C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 18:09:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AE046B009E; Wed,  6 Aug 2025 14:09:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 085DC6B009F; Wed,  6 Aug 2025 14:09:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB6C96B00A0; Wed,  6 Aug 2025 14:09:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DC98A6B009E
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 14:09:41 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 705FF1606D5
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 18:09:41 +0000 (UTC)
X-FDA: 83747120562.01.FBEF8D7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2E754C000D
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 18:09:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NhQjEvVt;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754503779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lp/xzAZFz2QzCUmaidxOhS/oOucGpdCu8iObUTLz2sI=;
	b=rCkbc3s3PLjrf66VtAsoka/EluoXLwDXvU7q9ykdLXWD1vaBafPZf0v3qq3R0O23MhKgj5
	YSaIO0U4DRGzTJYYMGAo5pn+IkT8qJdtp1F9CEnTHxLNb2Sz1C9NlK4dVt8iQbM6iCjY6H
	tBK4kIk77IT2uAHIk8FaT8daYI8B+uc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754503779; a=rsa-sha256;
	cv=none;
	b=ingq1o8+jRxzxe6ZD/E3OVw4uigRVvxyZn3c4U1jlxC9yBZw4LGO5o6koCDa7EsYAgsJQX
	mwwobsFJGlmX/s6TFWGI4Ryhhx64ml872KmSbqYXxKfDGBJV3VMwKBP+/39tVE3DVurpxX
	eslMwJowLwd6caOOHkKaW2KfnkadYW0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NhQjEvVt;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754503778;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lp/xzAZFz2QzCUmaidxOhS/oOucGpdCu8iObUTLz2sI=;
	b=NhQjEvVtUDelv1HZkaP5yzM2xlBgW8hgsI+9tJW8jzEuMyy5gIEA8W4B9gw2jNKq6CsOjz
	6ejNkYPGkUudJC5VDDZTeo3DcqvxrlZ0oHvBpAf2q7//W22bXCAkoFmKyWMtPOWS3oid0R
	wX5nin7lh5/quWWjLpBsDP9v1h3gDPY=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-80-6gF2PdQjMlW3y3MnM8azIQ-1; Wed, 06 Aug 2025 14:09:37 -0400
X-MC-Unique: 6gF2PdQjMlW3y3MnM8azIQ-1
X-Mimecast-MFC-AGG-ID: 6gF2PdQjMlW3y3MnM8azIQ_1754503776
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7e348600cadso33607185a.3
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 11:09:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754503776; x=1755108576;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lp/xzAZFz2QzCUmaidxOhS/oOucGpdCu8iObUTLz2sI=;
        b=sgFBxlCrFmYz8nafWG0ukyy5VCv9bRaJPO1sbao1UUmQ64klzucY+3wHB06V1k3t44
         WosA07yTGGQdwnqwdVuILrWMgAU1sfsY8FiY0NBp6zCaQUBOC4wf5pRp/g3EJnVqyY5H
         GaWIlf7EZ0gq2qFKOVQhVoyo0ZySd1s+0q3ozATEb7uU8D7r1SPHIY2EyQwhdXseJZSH
         00oilesg5ngdNnoXMW2UKgcDNLE6KZEuZA0JeHjCd7J/+HjT88JU9R5FXFO+iw0jH+rw
         115OaUuyNwbYS4nGlhL6QdBOsDST2lFUkHddNQ2mbY53oyQ/NVgB2Xa/0vzcIoHEpBLH
         MRDw==
X-Forwarded-Encrypted: i=1; AJvYcCW0RkEC1LuoZ2ELnCotKufXV79H9KTpt8AFTSjBQlLvoto45z5ihelryf4P//FKr1S48TbdVcFdYQ==@kvack.org
X-Gm-Message-State: AOJu0Yz4vmO8Cs+ukg7dVkTUB96yZO/5VGxqtzBWTtlFbINqcyMgRvOW
	gZ0mCq1l2eJtg920mhoNpNr/LuwyUNGomoRV2egrr3XVnOcTQvldVTGWLrMo1HeQvBCpjQEDA13
	l77iwWN7CmdqgpuoCqAEFyj+xsokeXZjDjy31BBokS7pYshOkuV4m
X-Gm-Gg: ASbGncv/3B6bBcS3WZsHjxOg+GSS0FqmgeShuXpiG5S+PItqmYeYQDlIIR0GAMaMaqB
	V621IxUx6MnGj4mrBVVkslShU6gijqqQAa3tgvzBIp97HEbBx3We8TejA7Eq7PjIW6GS+2zoInE
	ZnfWG7ieXlIbcSygM7KfeIVqwJCuJp09gFB4PP70AO/h1JahMjlFwrt3McshLqILO4vErOmjUxB
	vflCPaXLYvoUWHaDi8EBySWSuNhVWri48Xx0mUQoEEUm4VdCvy/bgQ6HATM7BPZdaXc3Ni8N+r+
	0PKmqY9Fme3CKB9CqtQuXR620H6bsQige+1ohZxXgo7AYPmW2LQXIdcc8Yvpy6Tx4dBame2qqa/
	WLwFIHfP6Su2YcJkQ77JxbQ==
X-Received: by 2002:a37:f506:0:b0:7e6:4fc9:6457 with SMTP id af79cd13be357-7e820b11efdmr25045885a.54.1754503776284;
        Wed, 06 Aug 2025 11:09:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEZUienyzEiTH73cCxQzcvtLeEUdg0Wbv5ywibHSA1otSIptcZDf2H9J5vbyp5qib/Hnxqflw==
X-Received: by 2002:a37:f506:0:b0:7e6:4fc9:6457 with SMTP id af79cd13be357-7e820b11efdmr25042985a.54.1754503775800;
        Wed, 06 Aug 2025 11:09:35 -0700 (PDT)
Received: from x1.local (bras-base-aurron9134w-grc-11-174-89-135-171.dsl.bell.ca. [174.89.135.171])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e81542b0d3sm145980085a.21.2025.08.06.11.09.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 11:09:35 -0700 (PDT)
Date: Wed, 6 Aug 2025 14:09:32 -0400
From: Peter Xu <peterx@redhat.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, david@redhat.com, aarcange@redhat.com,
	lokeshgidra@google.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH v3 1/1] userfaultfd: fix a crash in UFFDIO_MOVE with some
 non-present PMDs
Message-ID: <aJOaXPhFry_LTlfI@x1.local>
References: <20250806154015.769024-1-surenb@google.com>
 <aJOJI-YZ0TTxEzV9@x1.local>
 <CAJuCfpGGGJfnvzzdhOEwsXRWPm1nJoPcm2FcrYnkcJtc9W96gA@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJuCfpGGGJfnvzzdhOEwsXRWPm1nJoPcm2FcrYnkcJtc9W96gA@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Y1JgZ5g0WaF_m_zPIToF3pPUwvnApUKXWJFp61hsZ5o_1754503776
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2E754C000D
X-Stat-Signature: ypba47qraehgeqmfbq9kb6m8hpdqpgns
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754503779-572817
X-HE-Meta: U2FsdGVkX18iH1qADfJgehhcAidLPiBqT3OgiFUYo3+3IXBgnBpryrL2QMdJTp470h0mJdpA946j9DY3f99DFhQTMg/4xx3gBRcByTRqTsObAWez1EeJXNNG3pbow9NvknN8dCd6y70KXJ4qN/YPxB+82pAoFu++VjtpO62U/iGQagm8CLlTFvNe56NyYNJZR1H3ZjWDDJ0+cGQgPCBGA3bGj5RNdA4FjE3LeLiXGD4HcFAC4sD5BGwPyfWdU5KBeXrZb7MUwvlLe34vIGszZVflpcUX2hi4CAz3nOFmglQjXeLkSBw6MLtwEg8KSmEUoAvI2okWRQ7T2wLi8JgoV/4kA3lEl9+D59YbHcp6FLLXN+51GjIBb609nYG/QW5PTaHJprzlkomYeQ+rbTEo+K+hSn2IuO9eqP/G9SjoGyyCIRW45TA3DAKkUDlYPwTQsrx6NCRIV6fASa42ZH6IUoRwvpXCQeBAVVNr+/301k8+ke/d+Xu+5NaUEbPyX6viFGKkGyopRY1rmhmD++E98RqWN2ujD9K2cgCLfvmSS2TZQgdTx23TizaU+5QeAiXNeV28nFU7NUStCITRNV73r1kEXwqjBAAqwO5wvuYw1ltbO2KaVLtgt005Ar/Qpoit8fnd30EXi6m88WlBEEcFVktjoinxfHja22t7PoMO7QwbKVxAWgRy49rp8ERcVD7GWFrlaJnBoddN/WmVWIxyUFejLdZGP/9qIe9P8nITeM1+mGrLFY8nY64bnAvPjG/yfaK1FE0/F2LP+xQvn2IfSev/DhCbDBgfwrSrVyGgvVY26QZmrClaJt00a2hV2i2Pa1DsrB2aDG6/DggruR09SSi5LXO2Czmj0qjTR5SFQtIrdbcD0+OnxzboVyTRDm0b3RzfdQrCtGOvB+sBuOk5RGkxxvwLhb4SN7pp9z9KUfA5oYCPtxqEMkMG5cIg4S1tE3U7LTg/G0uayiwrqbM
 brZRU48z
 n/b7P/WADBDrLAA+galfMM4hhJWQmF7BEOYyCISPSuqGQliWcEfdhp4r6swLIF7BMo509SYl5y1Zs5D/blA5DYtwVhMDWW5ejF+LH607UdhOIzmymWusO19Cm9akCvHiZEgKrF91WrWrgenR1MDpUCvyNTyTyB/MDb3qhKxqFfepJkUgfaHZfjySFdk0N5mhKFm3QzstvlLGk7M+8Lo4R4SGBwpDVIICoY98tMzghUw0z9Ndk/slO0eA/9bQHCJuJM2WPjsaq+P0Yu03uoXr+6YMyaSmp4oBVS+ndZ1RW+x53hF6x2jEgwStBGNmQGnD39MLqSmh7t3d3DispGpZx9EsojqvQADclUhh1sSXB9apKvyQemk2IvFKXT2lXSYkuMY3VrL+Eg2MhVlUNmK8g7hLbRw/WNWWUrpBtYfUE15BtG4G0Eo1wrbjR1z3hhd3JBc05SurWNoxRDpYjwGR7JDNNdMCUMMFMU7c9UgX9ID3jxoubjte9aAAktY5UsTNd69OFKRuKfhBPavKjC/vsrCWdwgSUNM4jOGSsV/KKgVNCwh1fvlw1OyXH2TDx14mg0BXUYQiBzi7gA6eDJvXof4xcaED5UUl2kZahJENPLgGp9O/T1LAUu6q+v4pBQ957y/eggwahyudlnSJPcMybWHMjuneCt3ElEdnt6tbmm2qSJgk8p0+L70T6mA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 06, 2025 at 10:09:30AM -0700, Suren Baghdasaryan wrote:
> On Wed, Aug 6, 2025 at 9:56 AM Peter Xu <peterx@redhat.com> wrote:
> >
> > On Wed, Aug 06, 2025 at 08:40:15AM -0700, Suren Baghdasaryan wrote:
> > > When UFFDIO_MOVE is used with UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES and it
> >
> > The migration entry can appear with/without ALLOW_SRC_HOLES, right?  Maybe
> > drop this line?
> 
> Yes, you are right. I'll update.
> 
> >
> > If we need another repost, the subject can further be tailored to mention
> > migration entry too rather than non-present.  IMHO that's clearer on
> > explaining the issue this patch is fixing (e.g. a valid transhuge THP can
> > also have present bit cleared).
> >
> > > encounters a non-present PMD (migration entry), it proceeds with folio
> > > access even though the folio is not present. Add the missing check and
> >
> > IMHO "... even though folio is not present" is pretty vague.  Maybe
> > "... even though it's a swap entry"?  Fundamentally it's because of the
> > different layouts of normal THP v.s. a swap entry, hence pmd_folio() should
> > not be used on top of swap entries.
> 
> Well, technically a migration entry is a non_swap_entry(), so calling
> migration entries "swap entries" is confusing to me. Any better
> wording we can use or do you think that's ok?

The more general definition of "swap entry" should follow what swp_entry_t
is defined, where, for example, is_migration_entry() itself takes
swp_entry_t as input.  So it should be fine, but I agree it's indeed
confusing.

If we want to make it clearer, IMHO we could rename non_swap_entry()
instead to is_swapfile_entry() / is_real_swap_entry() / ... but that can be
discussed separately.  Here, if we want to make it super accurate, we could
also use "swp_entry_t" instead of "swap entry", that'll be 100% accurate.

Thanks,

-- 
Peter Xu


