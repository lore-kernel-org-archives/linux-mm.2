Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6647C624D3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 16:36:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 716B66B00E1; Tue,  1 Sep 2026 12:36:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C8356B00E2; Tue,  1 Sep 2026 12:36:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B74F6B00E3; Tue,  1 Sep 2026 12:36:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 320876B00E1
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 12:36:49 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AE4F980469
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:36:48 +0000 (UTC)
X-FDA: 85165747296.13.05D7257
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf07.hostedemail.com (Postfix) with ESMTP id D5E1440005
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:36:46 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ciq4P8YY;
	spf=pass (imf07.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788280606;
	b=urS0aG6RTqdsw1Yc5OLEqfjqJMu7R9StfcPUniidG3WNhl4tNkSddJn4kTETgE7B8P/3Lm
	FDMh/JFWy20cuI9msBWT7dx582rgiko7gbd44qnKbK+/Aul01wxepNYasbL935SZ1N/hcK
	bsFaL8S4DMi6sayBC68sbM2z5QJVVOY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788280606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EaYIWIHvKvoOBpgj/nu30SFwaFUp3YGpCnKBsBQBa0c=;
	b=EYgOZBg1M8pN5xjMV71ppzOTc+jxvJe7/S7FDaPXsO65crAMM6sZJVF8915hieCemrmxv6
	ksf7j+sO5sWwoqMox8C9UZ1SpnfYsr97l0tZlb5Sv93qhO8JVNHkJxxA2ZDT9ThmmQpXR5
	tvOZzkPmVuTSJbAgEbfJ/gAT00NLfmU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ciq4P8YY;
	spf=pass (imf07.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6a668cacdadso4437a12.2
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 09:36:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788280605; x=1788885405; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EaYIWIHvKvoOBpgj/nu30SFwaFUp3YGpCnKBsBQBa0c=;
        b=ciq4P8YYbr79EaPlndw/6TxkbnMymDUWQD0XxEbr/ZLHlRglGAVVpNSRWoVBXttZIJ
         YHYtqa1JUmtCxaxAZ23cJg0DAvPen0HFmd6c04tkfAGDaz2xByq2Oo2NeMceey++R7Ri
         qgFIGhFqSbjHEhbcMQKysVAVdWWPzbcqgNnUewNXPPH2s65ithXr3toOYjhjmsevBivn
         TtdxDTBdcdsYKya0v8POFj32RwyQKilBoVmBRD/n0K52D0Db3Ls8A3mQ8PwuARNUKryD
         B+sy2n6x9HyAdVjLtAoU5tZsMvyP6Lppv5+HvPbFVbu2Em2Et+yFnBU3Dnilp+C3V4p+
         oZnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788280605; x=1788885405;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EaYIWIHvKvoOBpgj/nu30SFwaFUp3YGpCnKBsBQBa0c=;
        b=lScQtqaD/Jktj1JftT2uCNaKzOVJ9N3Xf7LHy3d9UO95y3VLugZPCTvcDHx2WOi5sn
         ElgQXPdgZupNeqpfJkfDIi11mBjJgrnBMlyk5ZV4ZhwwSjVo7oxlVexnOphFuUPL46Ai
         v3HDZsA4dkr/MxAKdgRhA+3dlRW22UmVDS5wbTP80Eht783JsLrAEadgYeho9broRre4
         TpFdLodYISOt1GcAUj/FgPIMmWvt7QpbUrCcRWsEExy1pQulUZN1+dWDg1DT5KZT3Qf6
         kizdsCZn/qqL3mihPC/9lvml5ihCRFveJ9cCOYzEH9SZXA4UDTagJq7nAoKrUun0HwgJ
         nDyg==
X-Forwarded-Encrypted: i=1; AKwUvByma0CpF8vSrgPj3q19Y3/aoHiUD1CUhiq9bW/XURLvPFR/L0pfV2/e7zTiL0NL7KlTr+8aGSC2PQ==@kvack.org
X-Gm-Message-State: AFuF++l+iTf2NvW7mPjyDSD1W9ymXkutgdopsMdLpdWUQwGyUMSL/mdr
	Ze5Eoj59iS35RThO3m42YlVNmSYy15qBt6AacinTpucIBF9dqA71uCrA
X-Gm-Gg: AYBFou399cnAwkW94mZF4xyFwIY1FbfotrauA4/ZyQwK07bWO9GAxqEDx/TU3AlqiuH
	cuY2ILhyEHYWl5KhkY4TJZCrxpP2ITl+g2VtVfG3O0KQtNMlwuzrbFP5eMkCHDcRs4YDnyHfZSB
	P5Xtzy/xoGmbZjf6iFdqoITNeT6pnBPJANcKXxovRsI3LfHuFXD+Chm4dgsRrDbMbWL+my7TEs5
	+ZbRsd73OM+51JX8bxi4gwG/9sND9FUmYi8N9wkBQ33bHB3PBbH7LnS5vsWb0J/ufGeSs3ofgQa
	sBZU16hQ30aaVIlMQxr9hGuDI0xBKJ1fsruU4R0hxy+EBrMmL8e4Cn5/Lt8N8PhoNFpwkW345Ab
	Lb0eVfXMw6aXwaMrpHe/M5njtbGLtums8hMgGSWbWx6X6DM0CkdZKhw9Qw30EdHJhs+hUWsQFTV
	azl/3Y9XMQMF1QU9t46ioKE4FaAw==
X-Received: by 2002:a05:6402:24c1:b0:6a6:2419:8539 with SMTP id 4fb4d7f45d1cf-6a624198577mr14712381a12.16.1788280604911;
        Tue, 01 Sep 2026 09:36:44 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a67f8b47f7sm24513a12.9.2026.09.01.09.36.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 09:36:44 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Tue, 1 Sep 2026 18:36:42 +0200
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Uladzislau Rezki <urezki@gmail.com>, Dev Jain <dev.jain@arm.com>,
	Ye Liu <ye.liu@linux.dev>, Ye Liu <liuye@kylinos.cn>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: vmalloc: fix vmap_purge_lock livelock under
 memory pressure
Message-ID: <apb_Grl4I5o2dxKY@milan>
References: <20260828091753.299295-1-ye.liu@linux.dev>
 <20260828110503.e1eff32a9b7df9a8b2ddd4d6@linux-foundation.org>
 <bec5eaef-d084-467f-9bfd-43f7dedc1aa7@arm.com>
 <apVPTt9Xw8kSgmTU@milan>
 <20260831184252.15b978678820a94b106640ac@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831184252.15b978678820a94b106640ac@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D5E1440005
X-Stat-Signature: gpxncyz6wig6m9i74upw4n5oiefhkcui
X-HE-Tag: 1788280606-885754
X-HE-Meta: U2FsdGVkX197555Kew413+XuIqX44IKgidDeSGZL2BWNmJp3qo5I/6NLRHHtmqBVIQyt61ZcwGqkkaz8dJ4NMg0z1HFGbWhR8EUOxO6SKnHBdQgBOTGw0/PjpyxIBrnS1ERnLTDA5NsnP6Ioc2D5XaKuQVSLh/wD5WGou4YY2Qi4f3TiHqgf3oTIx2oWRfDloktvTK36M2YZ842CklPKgy+vXFHC/Z5Z+75ZowU1dJ/WQFriSaEKA5DJw7HiHMeAX4rPr2nwLwngxZqCQxS7Y6GuiELRn5gTk9Vm3iM19yWIt9Ri58lXjUNgtAYkqV3vtrzVhJVK2b32cqvXzRpnT/Iy11yYrAb3Fa9GvLWySTQ9ILxWmnv12Xl/wBPaRQLYgycXFwLo3MV4zjwzC1ocMGvogex4ur1wUrCvvTCkQiRO66Ep/isNFTJTWZPEMzOWIJRrEQ0laLZ7pa5JTMETAOzWCN0FDmWE8nPl43F1x7+HrwxdRCEnGjOHekPP4hQ0FMGYMfkUEB+HMFg4mVhAt3r5dWb/ky0E9Z2OY39gTWh9vJTKhuVn+W3p30Yk7/O4imfY9lMjfqX3ZU4UO+VEoXapUdGVy5I0f5zB7cnt1P0mBECnNgbzjeNjcmTzwoxtS/Yzpy9vwIIeYX+o8YFgIUOal89OiNpaceEAlwFbamY4q0cwXdCKuH8hh0qzl9ewkq9BmhfOOVEPknvHLywpqOtDkjuo0BUpmJAbHrunHKdagQzgqN8j5PYNouSwSyCWzoU+S6LTfVQyPVZe9NS+HUQjPSWUMatmH+zIHU8K5RJHMgbTonEsWU8S2/MQmg39cAgCGNyXDCKRCg9ULdYMw7ieWjXCCGo8rkvuhrZ9Qy4wsvBCO/C5aCR0fxeuu0TK9X3e3HH+DDkTJvGJY25rpIJU/d20Xcbr6RY0aRQ6MTQXDDgAWk8oWzPx/Gn4GGRcFOhgJYIzuNUohqlXzEg
 d/scjFon
 MLS++iR9+UHyJc2s5bC0oUphsXN+XMo4FTuduczK8w1hW7kUoYcF7WG5cvxfn+liG0PKdbK+qaZKjczUfoQneAQspffkaDQCW6bP49EIhD3uGRxIiAIPc64LLBNILM5i9spmfCZTHNdHgsTib+2WQom6ktUyl6b1nwykxF1/N/URzYSTY8vFLVYcKa0JkXNLqwd/G9QBXcLe8r0mPIHtjTXuy5iRaf59+9AUz99gMhnYcLsf1xN6Rccl2vMVkG16PNCZK1ucjdSr1WrUAVuxTFVFGj9JnQ9e4MDKYXvyObSt6lNtWTJsWTFXCRb+fCa6us0YpOLkNzC+XDVu5VG6dZwfq6hB39pZJgYZOe1xkdBRlZ5p7yyO2oP2EVGpSqf0I/48TxwvjoUoy+H9wm0O2HVPhGqt41TEyDwcErACwDiVCD3opJjsIaa97jV2mwbFojNoZIzb3ympHHS5Mzt+aBsBDlfb8oujdtwgNDI/TH3dYW7nC0H01Ih4vrTXtjHxbn5pP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 06:42:52PM -0700, Andrew Morton wrote:
> On Mon, 31 Aug 2026 11:54:22 +0200 Uladzislau Rezki <urezki@gmail.com> wrote:
> 
> > But, i think we can overt mutex_lock() into mutex_trylock() just only
> > in the:
> > 
> > static unsigned long
> > vmap_node_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
> > {
> > 	struct vmap_node *vn;
> > 
> > 	guard(mutex)(&vmap_purge_lock);
> > 	for_each_vmap_node(vn)
> > 		decay_va_pool_node(vn, true);
> > 
> > 	return SHRINK_STOP;
> > }
> 
> I *think* that means we can expect a v3.
> 
> Ho hum.  I guess I'll queue v2, under the assumption that my
> assumptions are usually wrong.
>
Yep :) 

--
Uladzislau Rezki

