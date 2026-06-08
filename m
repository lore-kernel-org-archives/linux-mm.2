Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BBBBCD8CA4
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 20:09:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A35946B0005; Mon,  8 Jun 2026 16:09:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0C876B0088; Mon,  8 Jun 2026 16:09:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 922716B008A; Mon,  8 Jun 2026 16:09:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 814CF6B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 16:09:24 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 75B4D1202E8
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 20:09:22 +0000 (UTC)
X-FDA: 84857834964.03.01409C3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id D58F2A0011
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 20:09:19 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=G3BA9niF;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780949360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mPGBC2/luUrvTKZA7fe3ursAMvj41Fm7p7HFv7E1PtE=;
	b=snQ/ONlCPpTzqv0U0bapE6tDxdzIKxOySoj4cIIKHB+twg1ITcxvujmLi5/iqva0Iia29F
	j6wJBiuiCVtocgX44rHWcLcCSL3UE/7xGcS8NneHCW8PUSyRO9EqDiCaow9PI5yMx8cUSw
	Qp01l053Vinkv/VyduQtEzkdy5RTAIo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=G3BA9niF;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780949360;
	b=B/Ti/73StpIUlIcicHPjo/ZgezqD08+/5AZm0hekdsABp+V12rcW0F6bigSib7zy2AXx2r
	g7CLFmAKH+YAcIaRTi72pIBS3pGhRybND869xKBoD6LUuLjBlHlezrOm7SbBl2qcO8X5ua
	P2qaXWHJ893JIKfJS4H4iEV/htJLMqI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780949359;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mPGBC2/luUrvTKZA7fe3ursAMvj41Fm7p7HFv7E1PtE=;
	b=G3BA9niFT3h2Ql040nIM/556ypXEG5E9N2oaNgPsNldbRltPGCdjsPK3elRGo6TGh3beHE
	ASnpIOXCBlk7k0Vpqv/zmPgfi3LrzrCGoWdzzfk3hCaWBZ4JQULqSxaC0ZS1NghRTMxVkM
	2S1GmA+wvNjB4hWULP9rQxQS7mTxFPg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-60-EYJJPPGKMuewEwN-9FJ9yQ-1; Mon, 08 Jun 2026 16:09:18 -0400
X-MC-Unique: EYJJPPGKMuewEwN-9FJ9yQ-1
X-Mimecast-MFC-AGG-ID: EYJJPPGKMuewEwN-9FJ9yQ_1780949357
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-45efa2f7009so2940007f8f.3
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 13:09:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780949357; x=1781554157;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mPGBC2/luUrvTKZA7fe3ursAMvj41Fm7p7HFv7E1PtE=;
        b=SsOpndZRmBW8BEfCnAoKERA29ZgnIgNpZXXv+LovcYnXsh6P9a5pIabRz9h2UiMH61
         IeX169GTJomGEGDVAAl/4tcr9z6IX9Om9cJW2YSEIJGMRXh7ErlQiHyzuaxtnlMgvzBz
         Gb8R+3POeUxk0SwS+Qu15jshqwShHhE/jLkHdEonsAno4G4ubnHzYiV7ujBBn3u65VzN
         /VdnT6ZlFomqgsz4AEPkJ+DJILnasKTFAM+iDDvgG5Pp3yv6Y0HcCmZseNt+wY+A3ZR6
         CyQ+ZGrjvWLUL+z+gp1857NlwIdH4yCkSoHzUZcd3YGuADWgizMfAJhWHrzpV1YzS/rx
         kk8g==
X-Forwarded-Encrypted: i=1; AFNElJ8NcW7IWJyI7JhgNgw4EcdJZ2/DcUHdOgKlEWG6bZcwYwy+t8lDi64zS/+C4xLJTbiVR4cxqSO85Q==@kvack.org
X-Gm-Message-State: AOJu0YxCSuvlav8OjSQTb0GJzDwcmWJxt4vSAVaAlGrkejgWqKz+5g9V
	IPRcu67iLhx30d60/d954cuwgdVeLeSHcbcaodXQelolf0QZtChy6Fq04j7j0dAPxvf/uXcOhoR
	N9OGZT5rCRpWbVZgAcuHKexp1yq09ZnebO3w0VeXVLRXz6f6XALu9
X-Gm-Gg: Acq92OFzhjo86ME+tevrwvIMByflOC+9HCkl1QtZPs3xMA7vkveMNXD0nupG5ftaCsz
	OthMl3Sbu64N3tMeQFxEQtGBmbG7PFigQc0YgTD662QznYZRRsplRGvZbdFaeloSiRSD7miRijp
	Q9ZJvt91NEF66pWDDLo6Qt7Zh/y1l7FrnB2KHCYiZmqFEf2XuZ4nbQQdnRW1kPRFN4rVZ7DPNHc
	YEsVnvPh2gZ0Sg7yB+KYrTVDBc3iQARUTyg7sS0WslC8le0DKxgnLaghxoPuXV2xnaX6PqXF6Ry
	MJZRb+ns6L32Acx/VzwSLBgKkPfO7vZwZ1AfwpisdOGluk5ZODhgoIVlslidySKFXH9gi/lYNEA
	TbwbVXam/3OohehsUszUzWpfavlD7Q8olT667rsHT6RMlK+LDY2NYKg==
X-Received: by 2002:a05:6000:468d:b0:45e:6518:3299 with SMTP id ffacd0b85a97d-460302dbd32mr18415839f8f.5.1780949356820;
        Mon, 08 Jun 2026 13:09:16 -0700 (PDT)
X-Received: by 2002:a05:6000:468d:b0:45e:6518:3299 with SMTP id ffacd0b85a97d-460302dbd32mr18415802f8f.5.1780949356252;
        Mon, 08 Jun 2026 13:09:16 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-85-71.inter.net.il. [80.230.85.71])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f35fb24sm58638802f8f.34.2026.06.08.13.09.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 13:09:15 -0700 (PDT)
Date: Mon, 8 Jun 2026 16:09:10 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Price <gourry@gourry.net>
Cc: Lorenzo Stoakes <ljs@kernel.org>, linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v10 16/37] mm: alloc_swap_folio: pass raw fault address
 to vma_alloc_folio
Message-ID: <20260608160659-mutt-send-email-mst@kernel.org>
References: <cover.1780906288.git.mst@redhat.com>
 <d2be78654e9dcc7cf5b8a542c2c8f331187c80c9.1780906288.git.mst@redhat.com>
 <aiapFvxPXuPd4-OP@lucifer>
 <aibm5OFmiFK6lCqH@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
In-Reply-To: <aibm5OFmiFK6lCqH@gourry-fedora-PF4VCD3F>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GsoPV3jr6aMzGViYIpIcuXgOsFogEg8ol2TfoVBIo_g_1780949357
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D58F2A0011
X-Stat-Signature: ed54dwi478mn1c6sw5yt7jy5up154sgh
X-Rspam-User: 
X-HE-Tag: 1780949359-599359
X-HE-Meta: U2FsdGVkX1+LUrkUZFDR4z6zkOvqaPtUG/2j4d806jWq4nq0L58RFkn0ew8KDmDDZx2bWe5PZOx36TGul2nLRg1MZoC48JlCif+HpquCivFDyRRjU8G6iunmzsOwzzEmbXKtSUxi9izb1OJ81TAj477db4uWn7QgArRq2MpT66ytsai+lRvL17YZY4eUWKus4BnXBNKHtNjfRGKVbpaWgUJdulYJSnRPKwkqpdpcPe/SuEuUtziFfnF0mzvr7HrPzFYqKxe7ja/xVm+XMa+7irj405OiKutrCJA49ggRaxjLEXqBDFxGvTUvcsie1Waty99NfBMoSR9QWOhkqGGA+FMsKLMAgzEQ4YnvRsN7BBocQSvyw9DJa6XU/mrzl0d+znmgICUF1sbQc5ZsNIX3n/rq2CHrO8pT2MsaEkBi3Sm+9a6zoS6GZw6AkbWdKShLyVjJXbmiY93kxQNBVo+LP7bV+5DbIZpZ/Pt93qT2xCdDmgObIbWH9cA/qKsDyKem5bkEj/bipToDeR2mFXXHbekQDZCZsZ0OJJOwPMERrgxKtXPAycZRQE8fY1AtZ7vEivc1VwtG5/M0ausinbg0qplqHeszfbyEdMD5ifEDt2RIVuIq0K4mi+O1k4GkDKm6hCL5O95UMowvcPIOj0vxRfkKy208CJU1zqhuh7oZKh17QNdL3zYJ3vCQrqFFm2sB7l5ePD/Yk1cPVbHiZyN0oV7wxENVuhwmcCUW1gfDOkgzXVItjXQgMl+gbHaFlbL2OGKQT3J2ChaN4LnHzRFKdE3KnTSQy+2BAJIWzC32gkzmBd1l9qHpIWB2YH4labh7Eb664oZL/uq9JAwioe1jaJESpQLrEYsie+BesaGiPSzyRdRH5kOXOk35kd0Ya/lUHCvTXxJy3u2ykbmbMRcGQ0fBHIqTj48kKveSdDe7H2F8k/TOE2ZzZMQ5jE22Jsao+9TZJ9emXhT2Uo5TdVr
 OhN0WBsy
 h4Nk86mR7+BAHD1s79hnWb4ydItUCMV0OXwQZQJALDenfw7/FQ+FQdRC3E3gEOuG4xQPnqT1E93ezbRrP0LvkB82UmRj25eEn+VUM8qKEqH1WyRnNwXHLC/c/cDYfg0YD/T6wfmZaEjdUG5LLTlpGEp1lZ1MD5am5LxIc67EkrZUFuQojC1XrpGi0Fb+r4toagg6rfpNDCCTasDzU0qOcDIkYeMG+I2rPC5/SP3UF3YCHWqnFS/jnei0GnHvL52ITbJ0aCeN9uxbTOxEi+054OqqVAowqS4KI+UFINSAZsWYYPpaxvTQ/Z/MyfqtlxC799TwRGfp4KfGi4sofYPHsDeJa6QTNk/G9mrnrQN4mTyZY2ZY4N+PVOPt19yXVuoHHjXsRkQ4JfMgqbPdlb4Mfx27WqAsesP/1HyXnqzC3XRBcSyWyKxIYBhcX6xIpK10y1lOk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 11:59:32AM -0400, Gregory Price wrote:
> On Mon, Jun 08, 2026 at 12:37:20PM +0100, Lorenzo Stoakes wrote:
> > On Mon, Jun 08, 2026 at 04:37:41AM -0400, Michael S. Tsirkin wrote:
> > > Same change as the previous patch but for alloc_swap_folio:
> > 
> > Please don't say 'same change as the previous patch' :) explain what you're
> > doing here. It's a pain to have to go check otherwise.
> > 
> 
> MST you need to slow down a bit.
> 
> I gave you this same feedback 3 versions ago:
> 
> https://lore.kernel.org/linux-mm/agXUHItfxSwtriRF@gourry-fedora-PF4VCD3F/
> 
> ~Gregory

Ooof I do try but the patchset is just too big. Sorry. I need to find a
way to split it. Or maybe Matthew will tell me how to make it much
smaller, he says he sees a way that will make everyone happy. Let's
wait.

-- 
MST


