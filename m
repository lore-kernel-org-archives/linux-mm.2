Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E95EAC79FBB
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 19:28:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB6766B008C; Thu, 10 Sep 2026 15:28:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8D8E6B0092; Thu, 10 Sep 2026 15:28:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCB946B0093; Thu, 10 Sep 2026 15:28:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A145C6B008C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 15:28:01 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A76DE16067C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:28:00 +0000 (UTC)
X-FDA: 85198837920.03.BC7372F
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf26.hostedemail.com (Postfix) with ESMTP id C9DE614000A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:27:58 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=I4p1Uaeb;
	spf=pass (imf26.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.171 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789068478;
	b=xIrn+yvE0rIDaf0mQA5rR9ImJnv4bmDMsZx9NEWd0CPrImOuXOUFjCkRAVBfP4ZsXFm4CS
	l6OaVPKRiV9O7NqnSbAWnr9g6tH2dtanfCC2cEY/gH5TtyhXZ732JhaYrbNr8ChaFDZdWj
	c5RiOIfMtri4Ld3E7TKSOkbetPBo2io=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=I4p1Uaeb;
	spf=pass (imf26.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.171 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789068478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=28iSeoWpFAMlNZNSVbchvp2DLH+zHu/Vd10+ndvitII=;
	b=r3gfUFwxPPTPz3xXOHDcSkOwIg1SSLZi7/9QD1CadJTOlWySrL01G0sJp2S1TBuvuvg6nr
	yLvNgch0JdzEe43ZWnLx/jIwbV7Ue7gHkChHbdj7r2y8gCZqF2DaoO9i8DOuq2saU60qT+
	RgqaabLTN/4iXucK2oAWN85Nm56vLn4=
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-9399daa3c8eso2752885a.1
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:27:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1789068478; x=1789673278; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=28iSeoWpFAMlNZNSVbchvp2DLH+zHu/Vd10+ndvitII=;
        b=I4p1UaebBg/sm1CyJ3OhaXUlFqlWrbddiuSqzME7ByJ56W2hv8hcH5shoDktr347to
         5AybWp4abkA7SwLLrN8TfyRCXfKRBblzhCf9ii/J2bva2h3Q9Z6vXI6vSZTfgDArBmme
         sR/VhbVXOUvtUhsf2wgQoB2Jf+q3rRcfXvCmzBrYQ0RDIRsDE+b1zoI0gd3/r+nhziur
         mz9jE0PPq2PHmmLH7TuBoPnaXdjb1CcnJvV3m7j4rNNKRkLfxujfEPg2CTM+OhcK37Jl
         jHvr4Nj7XF9nExmNK12ArdJVZU4hJPgHXxVZR4g4TgHvWYTaU66GuwnyHpyLa+Axiymb
         MuvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789068478; x=1789673278;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=28iSeoWpFAMlNZNSVbchvp2DLH+zHu/Vd10+ndvitII=;
        b=qSvlL00dBd/fF/QyWURbbQB8GdwQAGMiwkG7eX6Q8Wi/ubX0PmP9laQHmQ/jTlNx5+
         IWg3PaJQv++GZ/zbrDaKayZfxE5Hg+iEhUGZSGjqtCiKD6iHHqjaDkTSB400O0o5g6Cm
         bvCAidh2JMYlPHZ2UF11E60B6JZ5tfqLFr8nkKkjllz9JPyK37PkFOMTObdssvjs42A1
         9koVZXX0djwX5GDqJkreAmnobSuJ4h3XNm19k4wcSGPEnaiZJC0hIog9WNb2h691Tmhi
         cCQ6rNRP63aQoUzxUbmjN7HqFZYdqfXPTLIaKoAneuGs4GGmIWJnxS23p5WJ+Ws6R27r
         fDlw==
X-Forwarded-Encrypted: i=1; AKwUvBx0OU9BfLQRPT3aWt/93EftuC9LWxE4k3S4K0PNrU89jZ00sRq63yLENEV14Y1hxkL0Ky1Z01GxbA==@kvack.org
X-Gm-Message-State: AFuF++m3dO9SI3KmnVsDhF/0upoPnZ6axbwgTzCxGnSiAQVER32r3Pcw
	AEwDZKV6AmvdAzovkkB1l1flr6LcxkaLIXyLvi5uwj/8NNcIf0H5XdPltDWBoFeBEgEwnrRHP8o
	2FVI19qo=
X-Gm-Gg: AYBFou24TSwgDPG2WH/26S8HoCLPIZsvH+eKe3OUyHkzPeuxJrpL1WSS155W6vukLko
	6U4ZtW5fM9VEnr9mU72fm2L8gQ/VGpHiTDUWx+KDpmMK9Rwr8+9rAnLyGfkbzz/DeObmxLhRerQ
	LqyvSSB2Nqd1m5nfgVkHWCE1ovm7DA4SII9fq9nQSiYMK2nURKD8G63CVkje/r0l32qQcMoRm4V
	wl8sucdEjz4s7ISqpvf4mxk2DZM5EDjbRPherW2winbglTxPPgUL3ZlKChh+AsTc8DFtqaD8cHn
	fgDMDMt/GspAV4EO0SvOU6T88yc6r64QQ8ZWzPz1sZdKMqwZbCfY8Vt8Z9NSB/xxNBobdcJ5tAp
	WA+zWzkzjEx6rrDExqNkyKQF+MIeL0Z7cMLJDkogh98BhVhDGgaT9jK3Jy9IJx9NsTFHkxgcCLv
	gudqVshBLMXv11LpFdQX/6fnPYTcF7Xi5uiS0UBYe1X/dTubFKiXnU8b5z/8ei9bnJwCXQ0g==
X-Received: by 2002:a05:620a:4494:b0:939:6dbd:de57 with SMTP id af79cd13be357-939ea13c653mr46781485a.32.1789068477714;
        Thu, 10 Sep 2026 12:27:57 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-939e80fcee6sm55720685a.45.2026.09.10.12.27.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 12:27:57 -0700 (PDT)
Date: Thu, 10 Sep 2026 15:27:56 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v2 2/4] mm: zswap: reuse zswap_invalidate() in
 zswap_store() check_old path
Message-ID: <aqMEvL-fQNGgau4y@cmpxchg.org>
References: <20260910095449.715183-1-wangkefeng.wang@huawei.com>
 <20260910095449.715183-3-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260910095449.715183-3-wangkefeng.wang@huawei.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C9DE614000A
X-Stat-Signature: 47sje7n4hfzuxgceafxtp86pdnbq13tq
X-HE-Tag: 1789068478-184878
X-HE-Meta: U2FsdGVkX19i6Ll8o84SZGVatWfdf4KYITgKQT8nlZCCadvi2lbbR34cl4v01FjcMkjca/GutOorrlq+VI9EvQPylO7IDV0ETxW0VonBiDXde0NU6y5dmB5bBxJUX/U4RuBueM44EZJaBN/JB0hsTRk+kEAw4BcEfzuhBqMTxaBl9QWyhNsZs+mq097BQ+SHTMWxLMKKK7w2Akv9qTLvQyqiyWHKZtS17diT3fwwtRvEcRWK4BcqislccWi/v7MTLN47reUGJ4ulz96zMIORjGVn6VtRRjoJEYSDRNmDYz0bwarBeYw6c+/XmxEFuoWsPg62UUMXIblJHx2Dc8tbdAEkyrOHJWReVzptu0jEH5W8d4q2AVD9j9M6b8bJj4NspfFvQ+4aTp44Z1GfIZ6ySMjbNkUktZsakWGemU7neTUGFJfVodbBfBNWVNwRMmuEU/j+ax/MZCMsZPKrvgSmfIjbQdcYNYlH/HRq3GiXmMugzHUN71/qtktjdEOg9pdMnJns1U0YGWg6ypb1tcuyCASzRJby+sLIYwL1Zgw8dKsBZ36HlFHMK7CCBke1Ofcz+oRWum/mHUwPC+w4GTb778ZNyZbFJmYppJOh4b/9nOHb93rIbSqOC0/skRIcyqAfKemab8bxON16n8vOHiZHXsXmOTXmXXq+1CJAITArTGYPZXq8zFPtB8DRZzAvVYZd977prOk6uuUhpTPqrsPhuJ7mY9CBhiwnERX6nT087tMKoWZEX1KyTsq2Lkr1voic/g0l5lSLXW+cCVp9gK1e0aryIRv2a4yMNHhBtirx0iHesQ3FJjE1Z+YVSJ9BkxNdns9IX9CUtCbLecTLUBMgO0NAVzC0JBo8ii9BjAs2OKmpf8cVJx1i8aqcctAAtfWPNIPsuP2PT+yWos6PNPJYr32BdGYmBDhODLc5P4ArU2RrMMGSem4NUzxvVTG69+bIVAVEzms+Mtn3ja2/k07
 wQ/GgzhT
 VHrfVF6jHB+QZey9xzi7wboPZ3ra+J1OmEaZxAv5kl05PXpVpMplgcVW31K/P7D8/w8y9izfWE9tB3n+BLbn82qZsIH2v05bmrTw7UnS+jLsDuq+t8VXItzxh5j5Sd+BC9vI/r1cNNXb/eNkkitilCyRYbiR9mjPuQvYGjNqth7mqqyROPnR7CTHtKIQxv4OB7MTDSjOuoqKEHOc1iKjTPtFDexGzWh6lKtyFtbJkCNOuGZU0i+zDZJCB3PQduxiky8tSFM6xZh0da9diK9wk5ZQhEcgV3FffdLQRbwlGDY9E8XoHsGp2eLNWL+COmNKY/dQTFX6amP1QG2zK52J4IcQy2e9x1A9UCXy2isygQfZFIJtRTBuHM9gafMI8VZshAdXOjx8QT+028yhykR9+SH3KJHb7hMwinwYtdID3mOuIpeu6PJ9wp3nbc5Hs5+YLhamQoEVEDcMr/DHYyjG6Ic+tosHCIQUFHDS8uh0fbPM1IIrdDY8MIOGV6X+DKZ1aCOs1hgVpiVO6RU4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 05:54:47PM +0800, Kefeng Wang wrote:
> The check_old path in zswap_store() open-codes the same per-slot
> xarray lookup and entry free that zswap_invalidate() already does.
> Reuse zswap_invalidate() whose xa_empty() check skips empty per-area
> trees to avoid unnecessary xarray lookup and code duplication.
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

