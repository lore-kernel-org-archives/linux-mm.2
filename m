Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A525EC2A09B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 16:54:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C28016B0092; Fri,  7 Aug 2026 12:54:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF2336B0093; Fri,  7 Aug 2026 12:54:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEF0D6B0095; Fri,  7 Aug 2026 12:54:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 92A116B0092
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 12:54:03 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2D87A1C001C
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 16:54:03 +0000 (UTC)
X-FDA: 85075070766.11.6C3BB3C
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5D76E140011
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 16:54:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=gSwMa8if;
	spf=pass (imf23.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.173 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786121641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QphlmGb6n876I8v+NWQ/joPAkJz2IYvm5BS6m7aXjFQ=;
	b=4asmr/VKfKuIrbyVoAbkerkOBNz4AhEDAPj49G+n/+5XKeBmwCKldCo9GwRjkWmOd8O5yN
	gMg1Tkd3N7HX/Qydlaii7EoR0TSkQppGF56aYAioB5hU0NwgYYLa0e6E3NbDJVdUHDdubF
	m48enQOxxUHX6qZcfSRRowI80iMddig=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786121641;
	b=bmvDLqQxr3n93etC8I81i+l8O3bBSLdj5jU3ipucqYjlhUl5jKX/UIG+3IqMDsGsPYEVYK
	abdp6LYWPtoN8cIk1KsJReaeet5Gd3GUO2zCMhKSl5Xj/YrVVj2pGerkuIn5uLyylfdXte
	Ih13VBKJEms+hO5PNQG6XlpHZcgGn8A=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=gSwMa8if;
	spf=pass (imf23.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.173 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-92e7c6ec9dbso173312685a.0
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 09:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1786121640; x=1786726440; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QphlmGb6n876I8v+NWQ/joPAkJz2IYvm5BS6m7aXjFQ=;
        b=gSwMa8if1lbUAigZW98t1ZnJa8pNHV7WvChrhQ/5FPmFHkJG4qCr9vQOreYKFiRGgf
         X1i1QxdbXyo0bRKOINHfohuOxvAnnSC8tLMNQpeVFMrY9qw9cUNPWwnNbw20GCYWyuNC
         YoZTKa6Y2gN1Y7Eae2NnUgwVqD6ST0bMq5vv/1qIsqGh43dVvihfk4Gb27rTKb+MPsnf
         gaQGkEdhlA3Guk5f3+YH+ff35kqXFVRwbUBjZDbno+IZf8EZCIDl9gnCehbicZsb7Cmo
         FESCh1Cqj7ybTM2TNpkVtGIBzcPY1kO5Me9n7/F/31gsILivJ5dNMMxVjjCBHlO77lZ7
         UHIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786121640; x=1786726440;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QphlmGb6n876I8v+NWQ/joPAkJz2IYvm5BS6m7aXjFQ=;
        b=Yu0IWsgVF+nltBYx0StUl8ip2sMkufjyiFRa5bNgeFanS6rvqMdjVOsFoeC0mvkYIN
         kCJJi/TePnT9D0iS5ACEhuLxSGruPX1bDP80NRJ9Uf5FhPdiJ+jPK7D84KMuhcstyFXB
         zabzy2PZWLoK/POYF4efdtaI6OA2WI9tPon0uBLox2KOJcJ+MOxBs8FxZDBttieDXydf
         9oPLNxcWc9vWM+HaQsnib4l/DJyWGzNyWMUP+eAkLFc+lmipbXZOPT1tRpQy/BMsOJQb
         2tckKprFQA2jCCymWShrYKYVv7ehnOEYKjPNnlRfYnU/cF3Gfeg9kTXww3HL7vMskoXz
         wBTA==
X-Forwarded-Encrypted: i=1; AHgh+Ro6+LSmmQ44M3O90aXIly+O1Fm3yWFQLRaMSiCZ6Wn+v1mCk0pEJsfWAujBcUGScVKTdyZ9i4kDhg==@kvack.org
X-Gm-Message-State: AOJu0Yxtfaxi1PPkB77yG3lJOSUN3sxDs6qX2gqizUCfY4IrlJZKa7hK
	Fc+quCin9dafjMCdp0wtI4LwwZvwT3EStFBtrS6PoI3FMyfB8/g5NWo3VmULtO+7dzE=
X-Gm-Gg: AR+sD11NDOCE9qs1FSW0GHg3zIhPCC+fmrPUM6kWzF3kaguWVO3Od+ovZ07vU5UTL6y
	EGfDipJpbKj1REZ2Va7mKbvbuxC0UoU1djlGvlRB6aoon/8UGYAf/gEDJ5WCnr1CH+BYFQukXQs
	tzOV5jLGlR13GRfQUlw3YRyMa9vJVZYfK1agTVYNVB+IV65Kw1XSsjUQZYM6hTw8A+3yQ5yC+1y
	yEuSDQcQl2E0Lo0zdryPMElLM9RSHr52xUJtuaPx/BFEUdtx0WfOcwziDSqeoxrzvyhHhrn8nIq
	r6JI3UemZjk3bXMpcJWLfQuX+lxlc/cT3MwC2yJRju1HkVU9iRmfCZDj0naYjApK7Zov87K2bP0
	R3zVDPGJaD3OAFvd+nziLE2MF9gOZwxNVeG5+YriWLXYG9Z6EyhEs5oR+Q3prDIdKxKIC8aTezk
	Ca3JH9gQ8CJA9yXShD3m1ND5pypA14qtsUuJQT4nLs3U4UDbAsdtWk0TT8JOs=
X-Received: by 2002:a05:620a:a487:b0:915:e670:4021 with SMTP id af79cd13be357-936492e2838mr2269298585a.45.1786121640481;
        Fri, 07 Aug 2026 09:54:00 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9366e03ae96sm188388685a.8.2026.08.07.09.53.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 09:53:59 -0700 (PDT)
Date: Fri, 7 Aug 2026 12:53:58 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Matthew Wilcox <willy@infradead.org>,
	Christoph Hellwig <hch@lst.de>, Yosry Ahmed <yosry@kernel.org>,
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] mm/page_io: rename bio_associate_blkg_from_page()
Message-ID: <anYNplOUU0KrIHon@cmpxchg.org>
References: <20260806-b4-page_io-folios-v1-0-0899bac3b826@columbia.edu>
 <20260806-b4-page_io-folios-v1-4-0899bac3b826@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806-b4-page_io-folios-v1-4-0899bac3b826@columbia.edu>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5D76E140011
X-Rspam-User: 
X-Stat-Signature: caboijxktdgry6caz1nj6713rmt9enag
X-HE-Tag: 1786121641-439777
X-HE-Meta: U2FsdGVkX1/wfBBGmhaIgZk76EzCccT4GzN/QGJ8kzFoUn+bGs/VX2Ix8m6YoBC6MiYW/O5MDR5zlQaVAV7OUjNbVOJ7TIoVjC6ZTTuxSuQvpK6Ccjz6sneNWXCB4PXPAjjH2tMWLLxlmSA/VWniS0BGYgwVlAt0QnDH3B6xZuAogQ9/OLKQ8vvWXD/2+5H4Qr2/5SQAB/ZAyl29irdZBo+3rdUDPMuix4hYRqjiIBBeFOtGkTITv3Qf+w+86fEINHX6wuR/Yu+W1gQJa6VhBMBCvDWkANsss/d/NQknpzH/Vzsy13CClRsmlokqtSLw+05QXR8xtWTnFRBd1g1gEyN3rQYY5QJKiRGUgf4ZzTFhONEIx0rrU8qcBSr63lfUQ1HANVFrJ4BjioSkRV1s3r4Dbf2DLkpGArQeyb9LO0uWRFfvbp2jBZ6c2L2zglba3pOtEy1PCmlg8yWP5ZubHslDostmYVVelr22lMSy2fF3+7L5Fr9VUNpS4e171Ss2cmKgiGY2i1t6fKPE4p29t6OLztqn8C0lBDymlb6gZ1hzdpB6Ada/LahSo65Yn83nkO58lmW8fjAk1nEBwog2XEIjrm/26z0IH8e9AZ1ZRkY5JASSmt30CMjMtFiS7iHifrplpnEm2TUxItRODHRLH31/upiM0HdO6wqTvcPljynuwi9hlRZ72BEuFFoQpk6oUUns1WDxO4X8CPG8Ef5za6UJA3NtTHspoXe19JvcOEuA1PxUvPiNVOjk27mx2dgwzvdAULBf6VHwr5GTAxP6xeQxcXajIyM5fzRrAha/A82zAaqObFb+TRjZKbqUSYd/QQpSJNJal12ByCferljfTcak0nqOdKioln/XH5A09Y2tmvogPxe5am6FjoMiCf1ouEaR0hzq+JiNdXSTVQL/lXnb6AEOVg2HSJXD/tKnGQiYD0ATGUAlKFjzMadIPFoq/ZGZW3y/tkJT3mcMfTe
 42TSdYQu
 oSi60hjD4ZOonHWM8qWfY+wHXbM1l8mT3TgzVudLYY87qVs6mxwmCXsXIIo5pdMZq4EGTjMEytJeRxqDEKl+xp1foLTEWR8u5DahqmekNWPBj5kYQb6rSPq0ypd+d28smNyhk7WyS+Bq2em6nKgLd5OBoz4TsGJvsY7ms4pngZDvxQTu3tNnHw2aw53+Bcch5iWoobGIy9eyA/gNxIe2aGbFIQZYCpieDISVDpvoS3N3efZaUAScWds+CzALZ5wz4fKEFFw5GM6uPej5xhi5BaNMbq2OSXRzf/8FHPlCHhI3FSOrnXQKLaIL1kQWNAS+rwFAtL6fOezoDr59uh6wKom1Hf/lnsi5bhfFNusf+/lAgD9QMkw2GzZSeQiq+KhZeCNjhUNW18y/Vfneh8mO2iiiQClNq9CyDftdgwqsQ6nnN94Q56t94PJLcA0ASDa3p94pQNZlI3DKJS07qxFAdFCvbUBvgIEbk0sro
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 06:55:36PM -0400, Tal Zussman wrote:
> This function takes a folio. Rename it to
> bio_associate_blkg_from_folio() accordingly. While at it, convert the
> macro in the !CONFIG_MEMCG || !CONFIG_BLK_CGROUP case to a function.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

