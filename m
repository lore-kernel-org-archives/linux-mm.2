Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C43EBC79FAD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 10:38:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCFFC6B0096; Wed,  9 Sep 2026 06:38:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7FC46B0098; Wed,  9 Sep 2026 06:38:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A96576B009F; Wed,  9 Sep 2026 06:38:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 89D0F6B0096
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 06:38:42 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 06D401A018D
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:38:42 +0000 (UTC)
X-FDA: 85193875284.27.7423E59
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2E4B0A000D
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:38:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Wh4BXvQb;
	spf=pass (imf25.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788950320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YYq3nS25jNBeYT4d+3FQsk1hbTFGTjZFEKTMaefGWuA=;
	b=XBU4WMuKBCy+oWwPlOjb9xigQns86CwcH9fBW7Ohyx7M5JPkOzUnp45ZdqJRLSbKFjBhVL
	Nv/F8wSDDlO0ya+HNi1wUAsHc6hGpngl2RHx+K4OxhcD1454/7ZS8/cIBugALIW+D91Ty0
	Pv/zpQp9W5KsLrBgaklPtEknyi3jF3U=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Wh4BXvQb;
	spf=pass (imf25.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788950320;
	b=aRVlxq33mzvTXeB5h/0v41FFN2bjbMCdCFvkJZnUap8lg5SZN9x+b63kbIMP4zdmRbHGD4
	njLVX82dJL6E4q0i+u0mr8ATuXnPFePnLMbLcv4S/RH87nRcjMvxav0QqicfKY/YuLkmZQ
	avYKpX5f2rkJSg++fMRtY2IuZ4uLyDo=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-48441fa5c37so4157403f8f.3
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 03:38:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788950319; x=1789555119; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YYq3nS25jNBeYT4d+3FQsk1hbTFGTjZFEKTMaefGWuA=;
        b=Wh4BXvQbFP9BMtWAyYgs7EOQdHCO3PNqLG/EOpqbjvuOqqAmSZesvrnJELHWoo6KD5
         DjpHlBCfjkMiRgWx/DUDdpLVgSQBDe+FeMgxvSKrJlIfn78dyRhjvp0FgcoV4+HzbVX8
         A3/i7etwIcAx8sh25Q3lt3vfIyWEs5fQWO9CfoBSMupbekMo7+TLDLigID9tNEEddMec
         09y0h+ub9ntjq2t+RVKS6Sb8xhhdkCduAXKcyv2bJEAbPOf4Gj2agBop4n555LF4cKe5
         WHMx6T56a3s/R0FxYc1gTLvAEXNKrv4C+3HdDjCXOdUIv5BrMnae+0ui2K+6eYUV6dKs
         JU6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788950319; x=1789555119;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YYq3nS25jNBeYT4d+3FQsk1hbTFGTjZFEKTMaefGWuA=;
        b=cjiirdeevrypRjuEQaQe/AETGvX2P+NBeOhKiuHHqaiUp84PttF9NLOl0tNw3wryy6
         sRuhWKo+qzfAvbIBW46FXFhS+lc/Oz/6fkd96wQ7rZs+3PbsGsQ2RQzqu3Z20W4SpAaf
         78k5539Yueu6czg4u5CqLYPZErINjCCWiW6Mn+xnq5jLaPBw5wiyZJl8sFsnQcpXTETc
         90twzCPpDs6xBRUJfJQ7huZ546X690Hxk+Qe1G5nf+rQkpEvrlmGxUDc+78e7lCYhxTL
         2IXgiaQNmY1OGO6zQb+t/9NDbnhbOx5FrFol63U/Bb8MGQwlyksOR86zUBL6w2iOwbIN
         BUfw==
X-Forwarded-Encrypted: i=1; AKwUvBzV7+eY5nf2rXUpI4nIwoKOmnDR6dvhsW+ZBq1udD7BXcKZ/a8hmWRKqpBviJVmH4WoDxR+Ia5sEA==@kvack.org
X-Gm-Message-State: AFuF++m38vch6a1dmpkKY3wqOB4UxNaVZjcL63IszeSaOQarMalI8y1d
	Z40RvH4QsiwtYfY28PWdZre11dM6rNk2C29HC3sxJLGKi6lWJQz1tVX4
X-Gm-Gg: AYBFou0AWytPyQ5ScvQH/ZqklkxqohnJsonP0ZXhyIEuLQ2EHFWiM4q9mUKI5lnV/xt
	nTU878+DHWsaDptDSq4OvRsZc5XQprxzDbUP04bQFSJRcx2h6r99llI5WHje3/GvfQS/8gWi1aw
	Y5TGTPoDDECc2bY9/LyQI9Tr/8VTrm05GbP12docAMzN0cCdYShy00LmBSR89cmrIAzCq9RuUej
	ErGIeH9qLY+Q/uIOiZungjQzMJOXX82LaclsdvH/blMS5nq6pqDKn88L3zmA6Fw8rwsL7wPbHTw
	oWJoNtWEgchTrH92myTOOT/X0xbfY6EGT0TbCSMAw7UyrmuzGhwWIbNLckv4paBln+lsAgisWoX
	YJBMOQetc/Biz5gq/vI00ovtI0su+NPNJnpzNH0bex2vr6UhP1UeMmJ5R9cCX9kjJsxAAzeOr1x
	sR/rF94zc4mAUCzjKD8GkqilTDrDDImvglB7hopL6Zw6D9P5cracE5+j3c5zB5FcsV4BShyB1lX
	MCTyF/4r4WBr9bDgtlbICso+U8oFnDfLSFjts9Rrbgw67w=
X-Received: by 2002:a5d:52cb:0:b0:481:51b7:290b with SMTP id ffacd0b85a97d-485872a7feamr29438228f8f.14.1788950318435;
        Wed, 09 Sep 2026 03:38:38 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-485885b7bfasm43514538f8f.29.2026.09.09.03.38.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 03:38:38 -0700 (PDT)
Date: Wed, 9 Sep 2026 11:38:36 +0100
From: David Laight <david.laight.linux@gmail.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Nimrod Oren
 <noren@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, David
 Hildenbrand <david@kernel.org>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev
 Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang
 <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau
 <kas@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan Jackman
 <brendan.jackman@linux.dev>, Hugh Dickins <hughd@google.com>, Nirmoy Das
 <nirmoyd@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm: remove min_free_kbytes adjustment for THP
Message-ID: <20260909113836.6cbe8d17@pumpkin>
In-Reply-To: <aqEUdmYnnQQRC8yl@gremlin>
References: <20260901190123.3511535-1-noren@nvidia.com>
	<d202dcc3-d7d7-4e98-a9a5-3137cfbfd041@kernel.org>
	<DL9XL8T6UG93.1T1NSJMI8PISK@nvidia.com>
	<aqBiVp405v2srvSa@cmpxchg.org>
	<aqEUdmYnnQQRC8yl@gremlin>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2E4B0A000D
X-Stat-Signature: mcdzewsutomr3tajnmd1keqaou3pdksk
X-Rspam-User: 
X-HE-Tag: 1788950320-149095
X-HE-Meta: U2FsdGVkX19fxUBHUHNEy1YrIymtdcKFnfMNmuH7+Adhm4jzlTXOQfU/hmqMSLvYt9oFdJOBE+JZMxe7EsRtfMkUtXrTp69QFRehWnbND7VR5cPgnlv+RJzXh7l0Evew/YFePc8W8cndMvIBFsKu2/XXwHZnvU8pO5+wrgmKkq974EMPo4yCnzf+//nne8EYGeD53xAc4cj791dN7gBcQ7b+CSi1DrxOc5jLZrC2jqb7lgLUArPWm1uW3Im5qDXuVZx84HyqUruMFb/ksJkdLBmVnsAOLnIIjoOPBiuySSYR4K9cFzHDHRemRhuJLk9sg58h51TfIDeOzuvd9HDb3wrbhFfsZ8hLEjOkKzjt4ejzwfdfUcIhzbEdvyyLWVI+rFc/AAXIwvLecQNoD1jVSZ2b3v6B7n1SwRyyzEzlpY+RGfhNYBiOp4qw0pTuD5HGMrgR4yQUdri+km1CJFBU3llp2RhUNsajzPsouapmUT000ZPCcIkbi/+TeO0wYM8Ifh1zOwH5rcGdnUMeyHy/1ZX7gy5pLoVTdLlqK/cMKePLIh3B4CoqLCco6h3FWPdxJ5XaDSY3SKD+9DbgLt5MueWrGGXOWxczx9NXyzhsDOQ40osV+0n6yVeFmVxnfHu+IaXzXqUk+MfrF+ihW8n5r19XwLy4LGfccO3mm01NpZtD9v0AqC6oxY4uoJEbdpbd0xyubaMgg9D3sRIVEXcsrCxTPTZQGMEsV7QsP7PvNcsLf93HbJkms3sgBuZ/zWJNg6GnKEruoisd5BCM5v1RTwIVJezkccxSxOLFzal5iesWnZieOTEeYDSN814LgIYhpnx6yF4jiVItuLsE65aO49Y1bMu1BPNKXPUcdUtBpofNChxckW4INH0FeEL6awd/jWa/oJBhvcyy91zto6t8viVM7rYamv4yC3bmBkWF+F0ckVe7lNRgksaelpBEaYUVahZ93xpBn/BQ6hIv/cj
 yY1u3hou
 IdtrMexkbfPRqDTM4Rw1DB2mZeqh/UzYxJLzX6/ED8hQg1TUr1Maqq8RT0jTDmVmkVy9bp8zXi0O93VxHUK10f03QJup4gwR7nVyTwdm/14gjlreCFJJ4uPTq66nVASIxlbLgsR/p58H+YfAvlylAc0x4rmsxSDWy4GTbvu7yjMnhrGdLoBCQsOcR4I2oPQwXSPmotZvcs3xysEe50RPA32Qf0JrTJwd/vdjXmHgV4fyIahCEqMTiJGqiVn0cze2C1x217STaSUSfpDsmotTkxgeXKsc7dXF+NR+FnVWAFDIeHyJEv7J2f+iKuvGFOizRKfZW+SyCRQKJPQ/Q+oMl3DC93uEJlFuBVw/mWuIH5epF18Ru1h/MwJ2KpepxHVltd0YtYh9zGzpy+njcPYQqudILYLYqNyxEMPrKAOCWw5nK74DmffLKeLrTrtpAwVKR+8ZnH5QUijnqJQMN0JxT+dd8FAE7Xg5JKKmWX5xMxlM8/BF25Pw75bU2au2mt+peTGlV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 9 Sep 2026 09:11:04 +0100
"Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> On Tue, Sep 08, 2026 at 03:30:30PM -0400, Johannes Weiner wrote:
> > On Tue, Sep 08, 2026 at 08:24:38AM -0400, Zi Yan wrote:  
> > > On Tue Sep 8, 2026 at 7:54 AM EDT, Vlastimil Babka (SUSE) wrote:  
> > > > Given neither of the patchset versions achieved universal acceptance, could
> > > > we try just disabling all the automatic (re)calculations of min_free_kbytes
> > > > the first moment the sysctl gets adjusted from userspace?  
> > >
> > > Sounds good to me. Johannes, WDYT?  
> >
> > +1 That sounds good to me as well.  
> 
> Me also! :>)

You might want some method of restoring the default behaviour.
Maybe setting to 0 can be used (if that is just silly).

David

> 
> --
> Cheers, Lorenzo
> 


