Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BCB0CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 06:01:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 905838E0005; Tue,  2 Sep 2025 02:01:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E29B8E0001; Tue,  2 Sep 2025 02:01:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8194B8E0005; Tue,  2 Sep 2025 02:01:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 707838E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 02:01:44 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 13DA75C7AF
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 06:01:44 +0000 (UTC)
X-FDA: 83843263728.05.B6FA886
Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com [209.85.222.49])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2BEFA1C0002
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 06:01:41 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=F1wBxeAU;
	spf=pass (imf21.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.49 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756792902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BAarv6/0QyEvjH7hvgc/y53SwYGeaBvM0iEhN+PX0o4=;
	b=iYJf5GbJBasnZCefQliD5wDR8aIrEMN74boy6khVjjO+PCBoS+ene2qsuAyH+2U+d3fEM+
	3H+GgNbPJ3SLlHvnW5jpqtY+1e0tc+3Izr3Yd7/+/giN1vpOjugNbmmich1Zrrw+biZ3ko
	2E+FqfokbASDgVht4Efoo775RulF3wA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=F1wBxeAU;
	spf=pass (imf21.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.49 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756792902; a=rsa-sha256;
	cv=none;
	b=QkJ9wZ707HfMUPl34sf7O00k0+0ypZFc0jr7nbsbzPtNmIdFdIKQMmGaKyMZmw9Y93R5rz
	IFzoP+tk6M9v1Ebnymnc3ahWkllO8ueXsxG6lE1QZZ9CC4kHLumOYQlv0cq9MHmL9OnE3G
	SHW/T4LyU3vyFszJdM7C3JpjvAlabJ4=
Received: by mail-ua1-f49.google.com with SMTP id a1e0cc1a2514c-8972e215df9so376324241.1
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 23:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756792901; x=1757397701; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BAarv6/0QyEvjH7hvgc/y53SwYGeaBvM0iEhN+PX0o4=;
        b=F1wBxeAUhEKY5qmTsk4aHr0dqu5APsVZ5JMmvsrh8eyJTEc8Rl8kgYW5yhz4hWae1G
         e+nyzIGhzGkYwIS+mHG4zHci8MOx1U5BXJjWXnR08Weqk2jwMRX25m386HeMnWdn2HS3
         7EK/LK5xWF69+z+O8x1bDtwWTdNa9XOYqv2xI2Oaaq+llZtmXohPmEj76zuB4psntEqM
         52rbGkHejhOKRcRj4ffLALm8L10RATSG0TcBNwruGXQpYUUt7iVo9PqhhLGmx4CwjCl5
         tjSPvj5zTucDeYEdkjv4dEKGWUempTYr/EPCz5qYBZ1FUFT7fxNs+v3GrOMAW4v2s6yd
         E/fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756792901; x=1757397701;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BAarv6/0QyEvjH7hvgc/y53SwYGeaBvM0iEhN+PX0o4=;
        b=LR9FeUofPSkvN7xAdK4baLraQeBeZS7iixerWBLEIGvnY50P5Esp+68AVlZhCrj2t3
         qgvgu9aAxiKZ2NSYsm+CZ4d/NQRuXljylvd5gpO6O0A0u1nJDo2lGGB/RXg+kh1qLLZV
         0glKZsj6tr1cBL6KX0IDGA59SPSCbD08C288kIcPOC9gAuvJaTCli9EEdnZLWBT/OqAY
         ETgEMguuAXL9TrYVOuRPgkm3Qq2+fE8QO0+mZwlHmt5wnpbTFf9FwePtgUfcKCULlBZC
         i2pjasPMSdIg/PUv9nnrGbY/pqirfVgvAN3J6LryvvipsZ62u76oie9mPXzARvDCrLLA
         ZR8A==
X-Forwarded-Encrypted: i=1; AJvYcCVIKekEN2hwfYKbvQYGLGxVDPBUy3paUHu185JP9P7QmbyGCM5Uzes4UgzCJ0iQ9NOun2NXgnv8Gg==@kvack.org
X-Gm-Message-State: AOJu0YwOKaS5rbB0DLAhsNRmaD9oayq1SSVUN4rzeUR+XtganYb0WTZw
	nbXBvw0ilbtKoqIWxHKR8xZsJaB2jRt7hKwR2cv01npqzIV8BrbyEUGw3DjocELYDuRViguKRes
	u3E40fukK03e81qvX8dYDOWRUnPrTxXQ=
X-Gm-Gg: ASbGncu7QpKLQPKz70LqeWeAG+MifPs8a8JKky8CD7IyJUKrmbLk5+GkkuMc4XmegCZ
	CcCk5aLnuUywGtmmD4TOxL8gEzF7xUGhsJuKC3lRpxeTIjX1Vj069W0svwaeOnqSjMvyVIUEeGa
	Za85ZSIk31jIOQ309N1xIFB1qMc1Ibqjou9yYunW0HY+40BxZu6xzDf6oO/ZZPtIGaCqUqdtwo5
	ufwrlk=
X-Google-Smtp-Source: AGHT+IF7dvUUantLmFm2kfY5hiNCCQPwaFNajDYulh+zlXf+v566lnO4MCnjDtiXtFabbKXyu9BAsQ/OhzLUud+QAQg=
X-Received: by 2002:a05:6102:598e:b0:4e6:edce:4b55 with SMTP id
 ada2fe7eead31-52b19331f18mr2871291137.4.1756792901127; Mon, 01 Sep 2025
 23:01:41 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-5-ryncsn@gmail.com>
 <aK5/1so7a0i80+dz@MiWiFi-R3L-srv> <CACePvbU8pnjWCiWcSXRr4UdpuD_wdtrouLMz_fNB_=KRrdHLmQ@mail.gmail.com>
In-Reply-To: <CACePvbU8pnjWCiWcSXRr4UdpuD_wdtrouLMz_fNB_=KRrdHLmQ@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 2 Sep 2025 14:01:29 +0800
X-Gm-Features: Ac12FXz7vDJJXwXvCBE4eyLwhQ5IdBgtbVP1rFmaWrdYeCo_o0nmZuNulWnB3N0
Message-ID: <CAGsJ_4yY45pv1uGEdMMTsLR4_TmiCvzVs0Nvj9AzPXyqi5-gcg@mail.gmail.com>
Subject: Re: [PATCH 4/9] mm, swap: tidy up swap device and cluster info helpers
To: Chris Li <chrisl@kernel.org>
Cc: Baoquan He <bhe@redhat.com>, Kairui Song <kasong@tencent.com>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Hugh Dickins <hughd@google.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 2BEFA1C0002
X-Rspam-User: 
X-Stat-Signature: msyinwfj5mq6s8ph1jaxgmcrcrtrde8p
X-Rspamd-Server: rspam09
X-HE-Tag: 1756792901-514759
X-HE-Meta: U2FsdGVkX1/SAFkvX+JPxwfK3jEGbIXN9xcHmej33D1HSOPmTS4e49eMjJMPTMJq3vB6bWURJvwKJxTFc/ay+bTBuf99ir+FSeVuhMHIz0s4jXWl/NCLnPK11ZTl5N53mOxgbLj9MJgoHeRyWa+0bVbzj8PDc948HYrMX35Nz68IyDO5i4FjZ59xFm0YETAHNGbGqfcldYF6T4vEj5e8HajwMsqIxZyVxPueo8KLrWtaLr4rQo8OK0OsAgu3yM9HcDVF+eEWRRXOaz4lOTa5VrwlUatZM/rDdu3Dn5HiLvutCClCzyJWuANHMmgZ5nGblexmFN48dbnIvuHtCHiF3Ru87pBD9zUb2DIbLd+WnHFfY8OYJ1/E0j6Lo06pXgGuwKwt2ugaqZvDjKsTYNDIZVN69krLtvBO/REafCKytbYZuNoPLzVN079zo4je60JZQOTi0YzDx5LJIOA7vYbsymxeWlmlbyqeN2HqVIPgL9rJBRjSkPHw1SVXdJqOmDMlGBtGXAlaWrhrbKZpo1jYaxpxqIRH8s5TZh4DME9OSciXkyOAy+6qTr/cURqRoNUvoHHEU/SuulrTVci7axjgyv46gOZ/mn3YA6P5YobrPABG7zW1LqW5Iodj6EIzd8nrx8FW6PehhYUfiuhcbXrMKTz1KWbhsA5f3u1salAutCVjXt5zOuARVonfgQJ76H/z0R/RT8kLf8Ee1h3l0Kbu4CHtX2Vt/86yaF4CiCtcfTKKjIEHnOfajJH7i8jTAZh+CSvn+MV2SCC1n1qCcs1SGC3E2OIo4FgplFtrh1LVVNejuoR3bftoPKvqs+6sAo3Ym/1W1cQIv+dpQg3SrKqgNnuPwJh/mBIIL8Ev+i7Mfy/P+eoZiv9qe1aOPhmOL5pBsPpIW6x1O4PSDfcc/R6wRETTjC44r2qrPyliL0T/fYMTV5N7w9V+RTEN6W+geu8cEZh96hJtxzF/LQCSs0x
 z/wBNfzl
 dNpTHsFu8EgEBg4m80KzCyiECNIWDdTF6rajiMwSwOe+2tsFEHeR+6sLYpNAc5qmrXAvqT+Z6iyqRl8A3qvYnZ843JR9N1fiK1oiWfzkTSVg02a20VsxYvOdWdtuoNzBrHs1M3eLcUcfqXq4bLtx7H4fxKkVnbhzFqIBYHlSS01iuHR/7yCqBCakG3H9amAtrR41c6F5gRt7OSp4urce8koqaO62zlALD9NMLrAj/EERDvhJurT3KewTJkNW/8mt22Z92zJMhLIQLj84Pb6KBzy/sMTk5l0wXNSCLWAotWEU5akLDSTrC5HWr5zYbMmEG1AaNu02LR1BwMNyfLRF4NaptRiF94QutUk3ylrhEBo+/1VJh3Bjo+ch5vsqh63ASDStj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 1:45=E2=80=AFAM Chris Li <chrisl@kernel.org> wrote:
>
>
> BTW, off topic here. I really don't like the "_info" suffix. Anything
> you can put into a C struct by definition is some kind of information.
> Same to the _struct. Anything defined by a struct is a struct. Don't
> need to say that.
> The "struct swap_info_struct" gets two of the unnecessary words. It
> should be something like  "struct swap_file" or "struct swap_device".
> Renaming it is too invasive to the code base and it will mess up the
> git annotation history.

Also, `sis` and `si` are being mixed up all the time.

Thanks
Barry

