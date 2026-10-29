Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11D3B606A32A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 16:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=P/CIbl5O
Received: by kanga.kvack.org (Postfix)
	id 3AB936B05B1; Thu, 29 Oct 2026 12:24:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 383186B0608; Thu, 29 Oct 2026 12:24:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29A366B0609; Thu, 29 Oct 2026 12:24:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 006CD6B05B1
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 12:23:59 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8D1B9A7FD6
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:23:59 +0000 (UTC)
X-FDA: 85376185398.08.D05BE33
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf27.hostedemail.com (Postfix) with ESMTP id 93D3340007
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:23:57 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="P/CIbl5O";
	spf=pass (imf27.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793291037;
	b=oLG7UJ2PL0PMe8Os+RivweFpj7kG+hhZ2htwy3JVOtLnpKYRg57o3/xBN+mrmCkanXc90V
	1JRqXgRExgnloSRYSrlijqvMMiNYKp5/F2vzBpt7hE4uGnHdFkMIY7+t07PyuQK1ZOYZe5
	oY3bUId9wxJE6ryOF8kOPM/B3x/EKe0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="P/CIbl5O";
	spf=pass (imf27.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793291037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p7BExmyMwiDR5UEEieV2XRoxDfKEo1NhnCavqA/tY9Y=;
	b=mfAg1dGLX/6myvxLDadM9nJ7jhpkuW/DtLEiYKyBkc9ZKrLchKqywI+KSuxz39ataOe4kd
	6bMpGO4U6RvIRm952PtwutuT0D9zT2g4fGad7j0X/RYtuZc8immvfPv3Q6TGMGDpnBIILs
	DdX8ZnJzx5fJQh728rE1yOz3PDZ3FwA=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a4d7ae1ae9so23330325e9.1
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 09:23:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793291036; x=1793895836; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=p7BExmyMwiDR5UEEieV2XRoxDfKEo1NhnCavqA/tY9Y=;
        b=P/CIbl5O/wNQrrExdSmYYvMzCfJnppCy8NetBkpUAp5394RvsdAl+FS/T5tTt3Fkuv
         bOuJAksBn4YyoPbpjPOHFFwVDW4d/rSGT6yTh2go7YFwKB46nPaWTVRv3koiMLxHZLJZ
         sDE23Yuu33iUuY22La6+MYXVd7a72iW6hoiajecEzFj0uOATcRM7MxsOccBDn/I1xD1T
         StXQSfgWUs4d2YvC7WOXvK1H0qkgX3NBVj1p1mERALICPK1PyEurEOGvoApNPEG6lIHB
         QkN84fXZRmDclVUqb3Ut7ILGXS/mHudIVfB3LaJsLcnjbGbOoB/3Ys88o01jOmb96De7
         eZyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793291036; x=1793895836;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=p7BExmyMwiDR5UEEieV2XRoxDfKEo1NhnCavqA/tY9Y=;
        b=Jx9MckwAbsaBG8N+8YsU32524r0bbFGMbp8XHZVU+su2gtHHJlda6YELQcaggyOzJV
         EC4Su/VpxSh/hTPxc4zokCKLjeWfImgGVtI0pC++g+sxkKNFvp1AfuZkBnkvt0nMj8RU
         1NmqaVe/ed44wdLq06TFhUZFyetDjruP+Y0jQLWaYdCjuaKlaApFmIzn2woEnox/UpIQ
         ZqlEyzOkKR7AKD+Jy7yo+ToT43wLMlVaevwZKIZ+tmC264R5lolgadRy8TaujWpmsSZ0
         JhVdAHIlZPljeSfjzDLNhmTfTw8K43NsX76oGmhjflZhcT0rLAwGuSLc6O7DkR+BpEYU
         UIwA==
X-Forwarded-Encrypted: i=1; AKwUvBwd7/bO6EKOT8yz0wC9FGV3faH8DWF07+Kul4GS6ZAWcwZCj90kvVdIYkgquamAejjSpavgTOPm1Q==@kvack.org
X-Gm-Message-State: AFq9FYIfCol+t6HwAdvzM6OoaXBPGAdToyViUEFKj74KIhsu7IY8XmJx
	uJxaPy6pIeR6IFIxouBG3/TC3/Kgh0189JGx2lp8DMKybAPgaCCQExPesU8pdiwaoRw=
X-Gm-Gg: AYBFou3fPH6pV/RCsVnC582KP7iHELkMWOm92fgCIKzroq3VDvyJos0PZQ+FxpHb/HF
	HI+6h0Ne1vbgdp/5N3cYnfNYdGVTxkWvg8N4lBiFy8Qhg8ZuwkXhAWyPx6v+aVxhJ11zKAEa818
	GcNFlgRX+suaOhDzYCKmA/gTHlq/FeqHXo5Y1tng/11+ddIwjL3b9Rin4fX3MATIHBQ0/Iv9M79
	CnmFGAIEpq9K5vzE0z2UVZgNh6K/wKCOUPFBlqYGkDqD/cwuKfRE8NOkJCWKyxNj6JAT7Xtk3fh
	O9kh5H0vVuyaYJCC4B6fPddXNhAXLDaKIRkVTaksJ5OryR7aAX2VLn4w5O3Q4lXhedfPkjs6jSi
	uWlXfOHfHPZTwFz2PzZIvp8vGkq425vSSWUs0XqSr+wdYo+zHKgmelsuPQ8V8+cvt/WnkSDyTWK
	UdQT23futp9nUcRPrU2LhoG2RK0XeskJCAy7VZNHrktgi9dcYoEV/3u9iYpdNlF5bTe3iS9snOk
	09kyvytgnDV2FGPiqYaz0A29uOlJh/yFiilH3UTF+tYEvDUNeCtOO2ZugOJDt+Ui5wq3I511QLK
	iCu1fbmCPLQVQsuYdIx/7l2mnAnq6drVrfgQ9H+6hUU=
X-Received: by 2002:a05:600c:34d3:b0:4a1:e0db:8cf8 with SMTP id 5b1f17b1804b1-4a9643d37f7mr138287835e9.3.1793291036011;
        Thu, 29 Oct 2026 09:23:56 -0700 (PDT)
Received: from localhost (109-81-92-234.rct.o2.cz. [109.81.92.234])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa7ee575e2sm75886455e9.1.2026.10.29.09.23.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 09:23:55 -0700 (PDT)
Date: Thu, 29 Oct 2026 17:23:54 +0100
From: Michal Hocko <mhocko@suse.com>
To: "Liam R. Howlett (Google)" <liam@infradead.org>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Baoquan He <bhe@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Marco Elver <elver@google.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Graf <tgraf@suug.ch>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
	Lorenzo Stoakes <ljs@kernel.org>, Chris Mason <mason@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>, stable@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: Re: [PATCH 4/4] rhashtable: fix vmalloc() deadlock in atomic rehash
Message-ID: <auNzGgj3OqLTG0Cl@tiehlicka>
References: <20261028154218.1668182-1-liam@infradead.org>
 <20261028154218.1668182-5-liam@infradead.org>
 <auKshDXKQXt1kvjy@gondor.apana.org.au>
 <auMbCuecFeRmBFSK@pc636>
 <jfvq7vkx73vzp2ukq6nwnb3v3g2ezdcyppba4oa5lpzmz6ls6t@akc46gonndgy>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <jfvq7vkx73vzp2ukq6nwnb3v3g2ezdcyppba4oa5lpzmz6ls6t@akc46gonndgy>
X-Rspam-User: 
X-Rspamd-Queue-Id: 93D3340007
X-Stat-Signature: ia61q1xqja1haq8bbi3daee5u9f4j7if
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793291037-168942
X-HE-Meta: U2FsdGVkX19Or5dIEgCy8da04PKOLtk7EY5qpgF9eOxcwiztUud7DZMqIql8lfRMZmp1XM8xKh7TSnpJKtiD9ej1zi2q6HL4z+tBd+4Vgv5iJa/XuzPpIx4l/8yrhWtWa2Z1Os5J7E2TAOA0eai6GMy8+W4eRX/h2vgTsfJL5GvoVB1NZxkHSoYovq5BbzBkhfJ+3DS3geRFXRhXJNxfy2fVn83IBRmL3nRlt6t4KBio8coEs0eTQE2cyIyhcXFPu9sY6/kXDbZZb9HwxSiU8vh6lKoja8Pu8JpC+rn/kq+KzrSlTrPYgz0iLr9CibnyIGKyPCTVgRHQAP2VbQIu3EDFmFgXp+W6qM/SNXBr2yg8zW4LEo/UO3KcZ6Vy54mEAQgL5RPTAWuA1opipMDiXWnZjHe0w3Sxan9c906nxKCYWM+kWDzyj1D8VzMi9nCBwTKpgUZNraGD/Cn+bQL0/vipAovMRwgNxzPyr2Ug2G8YwHRYvcoY9BzgFFDnWgNfC6FF60KaKf4PsbWPgVE6l7NJVIHvQ4J7C3h9f3aeixf0GSgTiJTa1XGL+Kr13fCfUBOtXb+py9RKK6sOYYDjGOH4uEsvMLENBtDj/+PQQSdsnB+6JYzmbY81eWBcfIc4zWJkRj7+s7X9c5zPgzIUFa3DPz6iv2UrIMUBCKdCkRDAEz9WTSwa9IMIwz0JEKtnf5edNW+FoDrnkrrzOZKRBIn14K3/S3WDeKy511Jc36zXxxxD0vM0dC/d0EJhkPciXpufk9Kj1u3jXXXyUTC8nWVturhWjDVmfivybL7m92uGR1TWih7UbJqZwD9/11aPBNWXIHeA5hz6Q+VzGgqT+zu1KUtD7HCR26zu8UU1k6CaoHskGyWjrjfsab1CTYU4XiOXt3oMAhZm2LjEDtspxSb4MSyq4r9Q8hr5XUhN0idl9rcqDnTEqm3WZHjoIAs/SqYBfxY/4fiMBD58o4v
 r4US6Yph
 d/JRtMiK8aO4yTzXZrWYMA+pn5/S3k4QKQFEFzc5cH39aWwDXAZdze7OXrsALEYB4UAv5EnY2fN9OpPBilbvRRzicHspX5BPIcp0b4ZbLGwSNAxozU1Pd+ET0Liu1gXqFfUQ56kCRzU8wbyAJyaI6xJq0xAaeYbvhD6gET58bJwk21NVRjxBPRuRtjmWlQqGYVuvuBNnYjdncUBQIsMGrnjTOxZr/ewlp/S8kW8vvVKfK5efWwivnQ67QYZmEiAbSdruLpn0DwU/KCNnJ4CTuUN2XK8zJMTefwPeORFTTzaMHO/7GzzbnEPXatoMou7HgvzY8J5Rd5/VAdfl3l1JWP753tWQxC1schlUy/S4VlZWDhorLKb9xTBCGT59TbnpqL+CsaZEQVGC5UGlCDbFaNXhU/piS/xL2Sa2CNl5sGopUYNNuBIapzKiCTA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu 29-10-26 10:53:56, Liam R. Howlett (Google) wrote:
> 
> Sorry for missing the ML in my initial email, I missed it from
> get_maintainers.  I should have really clued in with such a small cc
> list ;)
> 
> On 26/10/29 11:08AM, Uladzislau Rezki wrote:
> > On Thu, Oct 29, 2026 at 10:16:36AM +0800, Herbert Xu wrote:
> > > On Wed, Oct 28, 2026 at 11:42:18AM -0400, Liam R. Howlett (Google) wrote:
> > > >
> > > > Below, one CPU adds an FDB entry for an RTM_NEWNEIGH netlink request,
> > > > while another CPU is inside vmalloc() or vfree():
> > > > 
> > > >     RTM_NEWNEIGH                      vmalloc() or vfree()
> > > >     ============                      ====================
> > > >     spin_lock_bh(&br->hash_lock)
> > > >                                       spin_lock(&vn->busy.lock)
> > > >     rhashtable_insert_rehash()
> > > >       kvmalloc(GFP_ATOMIC)
> > > >         vmalloc()
> > > >           spin_lock(&vn->busy.lock)
> > > >             waits for the other CPU
> > > >                                       softirq: a frame for the bridge
> > > >                                         spin_lock(&br->hash_lock)
> > > >                                           waits for RTM_NEWNEIGH
> > > 
> > > I think this is a fundamental bug in the kvmalloc non-blocking
> > > support patch.  How can it be used at all if it is susceptible
> > > to such dead-locks?
> > > 
> > > And if you can't use it safely why don't we just get rid of the
> > > broken kvmalloc non-block path and have it always go to kmalloc
> > > like it did before?
> > >  
> > If we have a look at this as we did not have vmalloc() here:
> > 
> > 
> >      RTM_NEWNEIGH                      foo() or ...
> >      ============                      ====================
> >      lock_bh(&br->hash_lock)
> >                                        foo()
> >                                         lock(B)
> >      rhashtable_insert_rehash()
> >          foo()
> >            lock(B)
> >              waits for the other CPU
> >                                        softirq: a frame for the bridge
> >                                          lock(&br->hash_lock)
> >                                            waits for RTM_NEWNEIGH
> > 
> > Same issue?
> 
> Looks like it to me.
> 
> > 
> > I have a question:
> > 
> > GFP_ATOMIC/GFP_NOWAIT guarantee they do not sleep. Do they guarantee
> > not hitting ABBA dead-locks or they are not interrupted?
> 
> GFP_ATOMIC and GFP_NOWAIT can be interrupted.  It's more about not
> waiting for reclaim (kswapd might still run) and GFP_ATOMIC might dip
> into reserves.
> 
> The issue is that kvmalloc() now falls back to vmalloc() for
> non-blocking flags (I am restating this to make sure I'm not missing
> something here, please correct me).

Isn't the real problem that vmalloc should use irqsave version of the
spinlock to preserve the locking constrains of the caller?
-- 
Michal Hocko
SUSE Labs

