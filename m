Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97A7E606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 02:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=oZt3EKiE
Received: by kanga.kvack.org (Postfix)
	id A7E246B05B1; Mon,  9 Nov 2026 21:42:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2F366B05B4; Mon,  9 Nov 2026 21:42:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91C606B05B5; Mon,  9 Nov 2026 21:42:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5F78E6B05B1
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 21:42:15 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C6EF71C429E
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 02:42:11 +0000 (UTC)
X-FDA: 85417660062.25.47B1831
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf10.hostedemail.com (Postfix) with ESMTP id E6469C0002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 02:42:09 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=oZt3EKiE;
	spf=pass (imf10.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.51 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794278530;
	b=Z1pVjyMgfdD2Uhjo3jG2gIGXkDQRoIHWDAmcv2S7wr9inoMaOz9vAUPUhouQaSe444adYT
	WjDU/nhaZInKemf/vyup/X9a9ZGdQGaW9gaYg3e8dSbD0kFZI+IBQf0OCkZO+zOPWEvAZz
	kFFr/iPCBGJKKwOwwYO0fBzhUcaI+UQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=oZt3EKiE;
	spf=pass (imf10.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.51 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794278530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9eYU/miYIaBNjo7DaB+0PRJT3BKcPjkG2A+IW4gcpts=;
	b=FPYXx9q8l4ZAhKcnSyQ+hyPIbWfcANwrV/NFzBaYpkQiv+bE6EYPoNQ090Er919q8QNOUX
	8PAeGa4DpOJEcQEmXlBXc2aJfTcC0hzqWe5WLBqHtjBVnf5PMxEsHeI7MGumy7oG0R+o5O
	kQJc6CTv+mDmx/Ec78um7i1GwKHG2yo=
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3ae1b34e0d2so857289a91.1
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 18:42:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794278529; x=1794883329; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9eYU/miYIaBNjo7DaB+0PRJT3BKcPjkG2A+IW4gcpts=;
        b=oZt3EKiEdjg/8XCzhL5GZQ27uWhRMLjyDYjERj5eNv47xyp3otKZD2GZRb83rGMkun
         I28990Hc6o76TEk3+56+aCBGuwBUU13ArVaxvhs8AjGeUQr7a1fRU8fVgNMWUeUF9did
         k7RlZzaf+il2CflTlCKiVq6U+jpR9Kq6Iu69g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794278529; x=1794883329;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9eYU/miYIaBNjo7DaB+0PRJT3BKcPjkG2A+IW4gcpts=;
        b=gupMoVVrHVxr86EKFaEtTLLf41Pno+YbD4nVUXln138QeP9IscC/h+8B/ZJwpWK6o0
         BMDqJDHju3TA63RoJojCL6f5aRgbcPVan99slWRKJH3zFy5zzo4aGCuiXDhWLs439Dpy
         RaZayTMwYmqZ0DDWvDEL0WwQnJxshwFi9v77vxhABCn6D2jH5rs0ElBLCc9g3T7JvEus
         I3iJNnI4bJ6GFqctLB1/9HwH23HSdPbOuzkOSwOOqFAEJFeQZLc+h5RsJQr3RQJQPe+d
         MSdn57VP6/GjelUvZ8+eJIJj0SFMLMplCRKApBnh0RoCi2LvgOfJM+NDdY0482vJv3ba
         0cLw==
X-Forwarded-Encrypted: i=1; AL+hErFG2t6QxMXG9BRYGFP24sHDB2G0kPb0OdMaYlwKLReb8tP9gFe1IM9x74PDx5KMHiMju89+odljzw==@kvack.org
X-Gm-Message-State: APuU4Z9oQp2V/cuD3OElbgiAiGdI/H+m0zC04pURNbjDj1plevK99s04
	MrpD/6gYLARk9Jr6zJf+9RBmQNIZBCv1+P+L3Azgm6FnSHiSgNTLzFf1ss9Gqio5Ow==
X-Gm-Gg: AYBFou1QwFNkm/TKBszqZCsHrL0iLQIuYfub76T7XQwRiYeJ1fuY60LWFnlOMIrA/SP
	Z+px7970UU9oaf1Un+WMzVWYrIAwsUGMwQvQ8MXEid5Vcg9+gIi0URCcN0eWxBS0HwCLkoz3jin
	QCstPWppqsJBZF1yQRIX4qeSAwhBR/jIWDhaSa2BIr8IjTxnHp34wDa3CceShLMSwz2O/zBscEe
	9GchvXny/9oKkqg2gkk0ZJr4UvAgai3eSkJX3CBmI6b9j0Md+lgOU3xHvEwHa0uEwo/XFdRFeeI
	G0zwdB4etsx/cB4tVO3Gt5S0pXr66Y1aNP1UV+EUzp7DA7JrYW8AwJgzk/AaEaBLWspDkn44uUc
	G9CFAiuq4pbgYRcHNexfeB+hHN+hJbwECrsTCNqdrDyHVkXGdMo5fnZ/djoDO+v897X/f+KjahZ
	lpZUnZ7grsrta1hZqZ53cnULjBloNySnJF5R1eV+k+ofY/18s6h6sU1JZQz4ACoduGaHPcjFKbi
	q/lr132gDcjeSBLF4Rz5ciJ2pf0xGzMmecr8n27nmGB0LEJ9aBUdCVslCw8AI/E1vxgsTgU8IO+
	aPGLYPjd4rQa4uFZcUY6hn5eky2MEETr0LGa2J2SaBddQ3ujs2eHguX1DPOpNqh6ScFD/A==
X-Received: by 2002:a17:90b:2ec7:b0:3a6:d850:bf16 with SMTP id 98e67ed59e1d1-3b1679a3218mr887901a91.23.1794278528711;
        Mon, 09 Nov 2026 18:42:08 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:e137:9384:7cd8:6e40])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b16792aabfsm1836319a91.12.2026.11.09.18.42.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 18:42:08 -0800 (PST)
Date: Tue, 10 Nov 2026 11:42:04 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>, 
	Richard Chang <richardycc@google.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH 3/7] zsmalloc: switch handle type to struct zs_handle
Message-ID: <avKEXEl5-yYKFvD1@google.com>
References: <20261105044752.1997895-1-senozhatsky@chromium.org>
 <20261105044752.1997895-4-senozhatsky@chromium.org>
 <auy19VvYgb25vnFc@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auy19VvYgb25vnFc@google.com>
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E6469C0002
X-Stat-Signature: g7dziappegnr3bhecfo4fo376mx38j4k
X-Rspam-User: 
X-HE-Tag: 1794278529-405073
X-HE-Meta: U2FsdGVkX1/wmR8F79Weu7XbMRlH/xyUeSGQlGp+F+7000A75gYxMkNk0OmlMf8spbT+7HGYDCU8tg9flFMVsFIIM//QRF4MrwKWb3sOXdNi7Hg9x1bQecc/YvQhgmvB9XCN2hcWWfHL/KvbibXsYhyE6Mnrc1kQxfg0+DmuZYE0tLI62QY9LmnVXjh2d5owR9fpwatnSvMduhXI8N0UUtAn5fWaGj6Rn4jBcMh/crRMhy0vee4m+NbNwAAkXiMCGcgGUGpLQEkHbJwsbBsAZOHnRTjWkFJrV5u7yfVEV8/AW24lkSBnc3XF3qNL0nS78kD8cNJgt45I1i4OFT4NDvpZ/J1Vd4/1XIrZL2CdmCs6JnqzGhrGNz2hlTgVr1blYxbOPLRELJK14wZ35TVIQc8j8Wn3cL1ejy64tHuHk/DmHRyKuVYWaoe583I17jLvOAJq/7jXBBNcuM+CNS4mbrK1uobsm+abGrdwtiRxlLze4G4r/JmW9x4zJwObf0S8BHNBnDrqNm/ky9Qhk+p2kSrcCBEgC2XS94oJskdgn6VWUimusaanC2iFN/WhIqtwXMuuq+CP0Qc6qg9jRDPemZTAXAy6zecXxExJF52/Z8ERHKcUCdDsATbPI2msnFSFkcvDcSKJz3V1bkI8qSr0DCKrF068YBSAW/NCHoGcgEu6TrSiZWwBdkdWoaiPdDQ0/OZEogEliADpKBw4ZT6aUPXvh56OoWna0kdRpSUbUjZKAwjnhrw1R040mKtTWGK9yxjWNfdn0iDNARtBAh2B2E8dQnty2xBM58jBpZXDwMxUjjJUQfJffJZCXlARq7ZW+Lcj0aGQf6VvDj3hGAQ0qFMlFwp1IO/kHy1P2TsKBXYaGC1YufcMO06VqiUvj3dKKm5Jw6lb92rDIHh5DA2bLoZep2+qq3P6zJIjChZx5vU+F2AvtfqDFUt+173AAUw8yG/8Q4o2ppOys0g++u+
 uKPZx3Xj
 4Ipcx6jXURnToAQi2ImKSQlFZODXmrhDTFklhgP5ci4gS7bm7/ouC2gmhzg5I6u2axVIue3jYQt5iEEyYCcf3m+R4vt/VrRZub+ufAFZ+XIEENcWI9YLCBSfDSJSGQP0Uhf62dg+WEYSaNx4Fj0lW25sd1K1PzljFKqnmISlXdRHUx2vmm4ALTM6ZBfjbgYbiqFDjBdNBS/vAvSkpLQrHS84zu/9MIfWGxF4uN6CQ0Lp54RSXSizGtif8yviST3W4c0QmBd8J4musNPWDpJTPG8ScnJ8YbWPM3wwpHFfocmJ2uz4h6GXzcZM1Snj7m8sByLvTBq6TuvqZbMfP2YxF7kIQ+/WcUumWcXZA8lb843qDAYvxcHLLUgMRpOUeCxLXfChqDd8t6uetUQ15PSI8THfX2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On (26/11/05 17:03), Yosry Ahmed wrote:
[..]
> > -void zs_obj_read_sg_begin(struct zs_pool *pool, unsigned long handle,
> > +void zs_obj_read_sg_begin(struct zs_pool *pool, struct zs_handle *handle,
> >  			  struct scatterlist *sg, size_t mem_len);
> > -void zs_obj_read_sg_end(struct zs_pool *pool, unsigned long handle);
> > -void zs_obj_write(struct zs_pool *pool, unsigned long handle,
> > +void zs_obj_read_sg_end(struct zs_pool *pool, struct zs_handle *handle);
> > +void zs_obj_write(struct zs_pool *pool, struct zs_handle *handle,
> >  		  void *handle_mem, size_t mem_len);
> 
> I would squash patch 7's constification here.

Ack.

[..]
> >  static inline bool obj_allocated(struct zpdesc *zpdesc, void *obj,
> > -				 unsigned long *phandle)
> > +				 struct zs_handle **phandle)
> >  {
> >  	unsigned long handle;
> >  	struct zspage *zspage = get_zspage(zpdesc);
> > @@ -839,7 +843,7 @@ static inline bool obj_allocated(struct zpdesc *zpdesc, void *obj,
> >  		return false;
> >  
> >  	/* Clear all tags before returning the handle */
> > -	*phandle = handle & ~OBJ_TAG_MASK;
> > +	*phandle = (struct zs_handle *)(handle & ~OBJ_TAG_MASK);
> >  	return true;
> >  }
> 
> Would it be cleaerer if obj_allocated() just returned the handle here? I
> believe this can be done separately in a prep patch.

Ack.

