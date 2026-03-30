Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C831FB3CF7
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 10:10:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADA3B6B0092; Mon, 30 Mar 2026 06:10:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB2606B0095; Mon, 30 Mar 2026 06:10:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EF2C6B0096; Mon, 30 Mar 2026 06:10:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 92DC46B0092
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 06:10:32 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 506035B07E
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:10:32 +0000 (UTC)
X-FDA: 84602309904.03.8FB2282
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 10D43180011
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:10:29 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TfqXpm1L;
	spf=pass (imf06.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TfqXpm1L;
	spf=pass (imf06.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774865430; a=rsa-sha256;
	cv=none;
	b=SqNb965bEr9n7dg3/Jk3qFN+3w7RnY0v55L8QV0wnjXiFCip8baROubh6xL8w9aSZl9ZwX
	tbokV39Z5cnES5kMhLLaLytr80WMq920hHr18PA5tyffXrJgkc6UhH84e9Nqod6LPr/Sbw
	uAauSy+QsUAUqrrHSkeULKKDRfZMdz8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774865430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HpuA7dRNbkH8Q1aS+IRAmWnuwSwaRl+82FW2DyUbGL8=;
	b=h40JFpOZnJzI0YEGeWxPqILvMzgw20mH0gpNhq7NFfLN/4+Y6CT9yR6PZ5grdiZhWI050F
	tqPcq0UsPEXmNlzCOLjoUYtCVwrwZgVafI2uzxDRZxvt4ycIVBrymltoBey41Bujp50OEI
	Wj3IRYzT5qQI249KA/rxK+M2OROjK+s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774865429;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HpuA7dRNbkH8Q1aS+IRAmWnuwSwaRl+82FW2DyUbGL8=;
	b=TfqXpm1LWK2mhNiLJXybN1g93KgBGCQHz+G0stEbKULOmLM6XG58TUFe448uzUAT9GcJgT
	VoJnhrqW5YPn3bdwwGssj3luWetyE167Veo78/Mc0EViiNxHoasqisMP/COKGnctZaK74J
	y3mRxjX2Y9YIdn9TqHUeOrY5K5f1g2o=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-197-Ua_K0qUrODeYSZRazvrUkA-1; Mon, 30 Mar 2026 06:10:28 -0400
X-MC-Unique: Ua_K0qUrODeYSZRazvrUkA-1
X-Mimecast-MFC-AGG-ID: Ua_K0qUrODeYSZRazvrUkA_1774865427
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2b24308165dso58248985ad.1
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 03:10:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774865427; x=1775470227;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HpuA7dRNbkH8Q1aS+IRAmWnuwSwaRl+82FW2DyUbGL8=;
        b=V+C8zrdbCO5F2kfKtAeFh3ZRxEOl2cRPJedki29ntWh1FkJ6z0I4SFUCryaYQkUUkD
         CKZG2M5Xv2ScFnPDbQbWpog0H/OnbO6ddxLJszd2odYUZ1gx9KvCkstYazCXTsXV8vdo
         RfufgfnJkjgRuiuWuc37wrUnmvPo8ng39ojmhEn5Wr/yI/FviDxkg89/kaQDUH+LRy2o
         zw6k6qpFfQ6AgwYI8/ie8g4XRO9GluFXp6HRHJXKaI0yb7c/ixncosJ/T6Lev1oLfcxQ
         aEbuVfG72bdFJAdfbY8QD5MFk8dOKGSkj3WrLg6cVwuI/A/Jlp9RmETRYUXTUDe0yfaZ
         i6kQ==
X-Forwarded-Encrypted: i=1; AJvYcCUFI1SBR3vRnhzXZaFphfamBSSj4rJg9VOH61OEbxEdd/vLz0SIQzYJuANmI76QLt39lauXxoi9XQ==@kvack.org
X-Gm-Message-State: AOJu0YzmzZ3vN08ohxNIA02RSbLJlpRP0g+/hNzCStDUi8Zs0MaA03UL
	UuhmBkMXAtUoTDXF2Q2LDNYilbksnf7Qgtk4lsHr6fjEeQeEwJrVAcPcB5ziCtnt/tqVNUESKzp
	NphJM/pTVNu39YJshvu5Ad1OLDlWhv0b2V/TatQwHX+SWIqFI68oU
X-Gm-Gg: ATEYQzxvy4G377m9xRRVY3rwgNMCQnEFUjqqJSJluccVLtqbE0lhabYGmSmmffpSfju
	OOeR5n4t8Pbwx9NcFAXXCPNT45QawjnK235OOY9dDo28Jxjcgogh++qTRI624PZHDxSE68j3Gg4
	7+glIThzMgh3PatqfKwQStyHNzLUdV/1q4+qfAS4B2iDuE08frRNX0ZLsATxM4Am2CtakJFL+DW
	vQtNChAHE00nKrJX8vsBecGzJn+oiOA8z1luq2ziDl8ZaRBw1om+XJMB869kQ5PyFeLYqHJGXID
	TVj5K5ngJZzr2ALLZVy5Ezo+KJiaHKPuzGKewhGyMiXCd5hD+8tgI1cTE8SjF0F82KLFrqlUBJk
	mANktu7LbWetV0lJAvQ==
X-Received: by 2002:a17:902:e852:b0:2b2:4029:d781 with SMTP id d9443c01a7336-2b24029dc37mr93217735ad.20.1774865427054;
        Mon, 30 Mar 2026 03:10:27 -0700 (PDT)
X-Received: by 2002:a17:902:e852:b0:2b2:4029:d781 with SMTP id d9443c01a7336-2b24029dc37mr93217465ad.20.1774865426569;
        Mon, 30 Mar 2026 03:10:26 -0700 (PDT)
Received: from redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b24277e8d3sm74371865ad.55.2026.03.30.03.10.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 03:10:25 -0700 (PDT)
Date: Mon, 30 Mar 2026 18:10:23 +0800
From: Li Wang <liwang@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, rppt@kernel.org, ljs@kernel.org,
	Liam.Howlett@oracle.com, vbabka@kernel.org, surenb@google.com,
	mhocko@suse.com, shuah@kernel.org, aubaker@redhat.com,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3] selftests/mm: skip hugetlb_dio tests when DIO
 alignment is incompatible
Message-ID: <acpMD8tRCJhgXHeg@redhat.com>
References: <20260330053915.75442-1-liwang@redhat.com>
 <a5b7add7-0507-40c0-a324-81f243ffa261@kernel.org>
 <acok3JY66OcV0Qab@redhat.com>
MIME-Version: 1.0
In-Reply-To: <acok3JY66OcV0Qab@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: E1t1142k7sF-VlCUnilKSnWj_mR6n5IGn4i_SSEIdrk_1774865427
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 10D43180011
X-Stat-Signature: 7bmrakc3ng571zaerruopq4zo8y3mdhx
X-Rspam-User: 
X-HE-Tag: 1774865429-878863
X-HE-Meta: U2FsdGVkX19Logm8A7l9CsHsVL4QzKJC0SQyRZ4UMagydNOqs8jqGJkNPBmgBk8eGsVW7vyrczMjlOqYZeMs7R81QBLIYp08FvtuyKd+TbA2kTvpPHEje+xM+tDOPJSmu2ePnfWyTDKVjRhK/3BIpnIh5YzhZ6K0DWDS95LAAR8MGplMnoniV7GaSJdrn3Tk0pWBmFlj/AKG0oe+V4Az3ybLY9RMfWEZMKcV2+NbjifXDWIF+R/yiOQiXsnNC6UesBhLHi4EvdwVHq3wKgqQL/quosF3aI6fABxAlMqd78Xmx2yaFU3Fzb02TeGyFvTyvor5NApnwCRCEulXb352ZT95Nsbm78Ij61SpHOtToG4k7ddktdimXCE5VyqN4KvGNPAIibAOVyxAfUtjWZ1F8Xo99G9tmSoEOiRwgVO4f/SaHfTdQsgMYSI1jk3HwDGtiktxlJsFnimLTWj4nAeK/Xqig4ReZgGPyTOZOe1p6DpG87DtA/jo0aj3E266v/yCuaEby0rraXA+MB0eGktxrZj/Hbf26xoSFlIMPsYbSrtN6jfJD6aKssA0kZ7H8IBZyHSJ7uH2ZsDicSC5fsiN2StEFUV0uTnSz1N4QEAortg8ehYsdwyuWqeAfePusLEwYaMaZV0Xkr92Cl5YIwUzlySwgiSLpaMIF1gtvPxb5MA4hEdCkqVMtTkOWPV/AgiQ73d6FH1cn/1Pd5QpDGL34grHQ48pESwzqOlXURlxXaVLGHL4mjwvbdu9XB2L00+RSpu7UOaEI0NhDzpseAZ30P0w5Oj5949ovzGATyNtSDgcD6k+pk/eEJPL4KT9SnfewPYxbljDRqpCIsV/x6+R3DQWhYKz3ztK6D0gV0E6ore6iL4eOUYxE7wY8wK6TKbnT4tllrxDi4o1vMMLP+dy/d8nmzetMqJBZWyfd30lWf83RwCn1QiiQ3Nq04/mM8JHtEeZKg+XwWiJzw/+DDR
 loCpnfo1
 S7TC55Gcug9e+wQk0h2PU4WLAbOEnICXKkAQN8SZJZZexIxAf37g6J+yTIAo1RnuacD33UL5ciiuLu/AqPfY+B3g/kqDbkFeZ5cy1bUm3f3KR46CfsTMBTU4Z3Y227OBssKkQyT3gOrSUu0Ab0dJo1bapA/KLOHYH8OYjE/BAT8GAtFN1uLhm76i/pEcT9K7B23UDVyDUuPDCeGhfqg6xRGgCdwFKYM/77y08N2kwLqiDaNna7GEQWnkvKGbZbSsfTF/EuxJK8L3VSlwNFeRp9QofG8xHK14M14VUvYkRg/jZpavWNjvXcAPRzIfldHVrirqC+90DHict0sIij4L8ivQJJ50hi/SbAsYT9wEefP9J8Ow7MYBQe50zXRijQyTR1qYFdU8i3WvGlNOY8+1BoePqpp6OuoxYJQVn5TJeDot2G7S1Ek9NquEw0DUq3+pXg4frXvMnHVvRkioasG15fYQL75u3dYmQYjxx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > Why can't we simply open the file once and pass the fd to run_dio_using_hugetlb()?
> > 
> > fd = open("/tmp", O_TMPFILE | O_RDWR | O_DIRECT, 0664);
> > if (fd < 0)
> > 	ksft_exit_skip("Unable to allocate file: %s\n", strerror(errno));
> > dio_align = get_dio_alignment(fd);
> > if (dio_align <= 0)
> > 	ksft_exit_skip("Unable to obtain DIO alignment: %s\n", strerror(errno));
> 
> Yes, apparently this is a good suggestion. Thanks!

And, to make the test elegant, I'm going to add check_dio_alignment() dedicated
to alignment checking. Then we don't need to pass too many args.

Tell me your thoughts if you don't like this:

  static int get_dio_alignment(int fd)
  {...}
  
  static bool check_dio_alignment(unsigned int start_off, unsigned int end_off)
  {...}
  
  static void run_test(int fd, unsigned int start_off, unsigned int end_off)
  {
      if (!check_dio_alignment(start_off, end_off))
          return;
  
      run_dio_using_hugetlb(fd, start_off, end_off);
  }
  
  int main(void)
  {
      ... 
      fd = open("/tmp", O_TMPFILE | O_RDWR | O_DIRECT, 0664);
      if (fd < 0)
          ksft_exit_skip("Unable to allocate file: %s\n", strerror(errno));
  
      if (get_dio_alignment(fd) < 0)
          ...
  
      run_test(fd, 0, (pagesize * 3));
  }

-- 
Regards,
Li Wang


