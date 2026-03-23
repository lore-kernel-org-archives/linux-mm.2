Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36410F483EC
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 19:47:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E3776B008A; Mon, 23 Mar 2026 15:47:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BA536B0092; Mon, 23 Mar 2026 15:47:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A9896B0093; Mon, 23 Mar 2026 15:47:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6A83C6B008A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:47:39 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1296A5CC62
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:47:39 +0000 (UTC)
X-FDA: 84578362638.18.013B6AD
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf07.hostedemail.com (Postfix) with ESMTP id AD5A440014
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:47:36 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CfcOVf+2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FZgaYQ22;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CfcOVf+2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FZgaYQ22;
	spf=pass (imf07.hostedemail.com: domain of dsterba@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=dsterba@suse.cz;
	dmarc=none
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CfcOVf+2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FZgaYQ22;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CfcOVf+2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FZgaYQ22;
	spf=pass (imf07.hostedemail.com: domain of dsterba@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=dsterba@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774295257; a=rsa-sha256;
	cv=none;
	b=GOMzSPe9JzN2xipSBFcCvJWt3/kyk8VWX8jn3IKrDQEsmsuvoGTYyrDV60qEI5Kls4g9Ug
	doYXI9ZFnhtbA9jODRxN4+EZsngkyJ2wqBbSOGcxj9oMIIH6/qVab731VY8xzaNGWYKdmm
	IfMqnC5ai7w3kgO9VTFDOimcc4+c9Ms=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774295257;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=prLONiCqlXJiiAxHJr03M3hsqyprosNVDfpQ4OI7XGU=;
	b=G6p18XNe+LM+ytsHzBZPKlzkSS2lY+TTzqjQjQLF3gcQCylaKgzCiUCDLTH0M17qewOAyy
	bSjM9Xp4VY6P5v1mfB7mYGD7AvhNAuqGSaWvJCtI3y05HCHHjOqrLhGazjF5iDETIxmCis
	KEF/1YWtuAcloskPhOEHC4sKd6yq4Z0=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 971355BDCC;
	Mon, 23 Mar 2026 19:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774295254;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=prLONiCqlXJiiAxHJr03M3hsqyprosNVDfpQ4OI7XGU=;
	b=CfcOVf+2EtjmXB9lMuGJGkBV2rEi8DmoLYvI4g8ObdtDFDxBADTO5q00gO7v3rW0ui7CJc
	ee9IglSpniLV7rqq3Hn8uBaDW9iMevELe7XCrnthS+XOOHoZrPUShYzh5+5+hRR6yX4rQm
	X4ABHiKMYzI8mrlQAteUJn6OEC0Y060=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774295254;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=prLONiCqlXJiiAxHJr03M3hsqyprosNVDfpQ4OI7XGU=;
	b=FZgaYQ22LNg76nbzRP0MzF7XwK31TkwHANuGS7cggIhRbKh8QIMbztPr5Pbc3/LoVrGluZ
	/xb89BX7wWuBRGAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774295254;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=prLONiCqlXJiiAxHJr03M3hsqyprosNVDfpQ4OI7XGU=;
	b=CfcOVf+2EtjmXB9lMuGJGkBV2rEi8DmoLYvI4g8ObdtDFDxBADTO5q00gO7v3rW0ui7CJc
	ee9IglSpniLV7rqq3Hn8uBaDW9iMevELe7XCrnthS+XOOHoZrPUShYzh5+5+hRR6yX4rQm
	X4ABHiKMYzI8mrlQAteUJn6OEC0Y060=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774295254;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=prLONiCqlXJiiAxHJr03M3hsqyprosNVDfpQ4OI7XGU=;
	b=FZgaYQ22LNg76nbzRP0MzF7XwK31TkwHANuGS7cggIhRbKh8QIMbztPr5Pbc3/LoVrGluZ
	/xb89BX7wWuBRGAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 66FB543A47;
	Mon, 23 Mar 2026 19:47:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id scjtGNaYwWlgawAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 23 Mar 2026 19:47:34 +0000
Date: Mon, 23 Mar 2026 20:47:29 +0100
From: David Sterba <dsterba@suse.cz>
To: Zi Yan <ziy@nvidia.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH 09/11] fs/btrfs: remove a comment referring to
 READ_ONLY_THP_FOR_FS
Message-ID: <20260323194729.GU5735@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260323190644.1714379-1-ziy@nvidia.com>
 <20260323190644.1714379-10-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323190644.1714379-10-ziy@nvidia.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Rspamd-Action: no action
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AD5A440014
X-Stat-Signature: e8u9yi4g4djmtnxt3dzuunnqe1mu1qzh
X-Rspam-User: 
X-HE-Tag: 1774295256-701877
X-HE-Meta: U2FsdGVkX1+3dk6d0ADUDJh72uUCEIxBCrihsQwKK3kqdx21suJ9qbxiwnnwGLBS5KGpmWQWwPCxtGQSNRKUS0Q3NWVr8wD4bI/wifOBlVHPz7AaxM3Vl043BKB2PDYE7llLiQlatYcAdXyUnFdphUve/rXOqKS7sY9oVsg0AChZ3THnZ05Am5bxPlJ0CketQe78ad7P/JUSGmOnyDwnWgO9gEHWy4C+qhk1M+8/Fk6L6zF7xT72dSYmX75EBFtaJY3+ghUZvZGVnXjsQPGSkiyRejD4fdahBk+gGy/6BGgsvySiawc4jwfWISZuHyNzQ77AHBTF/3AA8N44KrzEWfta7CUx4rCINc+kU2ruNEoXNm91lp0AZWgXBjfMB8EF0ukurSUUANVr9kr27kAJ3PjOHxiOKqNuwZYxN5hyoFUk1Xk7wLwXCW/YZdt+thLqJkrLaFHf6w7bs/J6ZqBc2vwriYeNF/JxLVFdJWCiCTPg4NA8UJIq3/tfr1qNEg7FMyc31Ho2WjLDh62M79qzlBA+ZQwO0h6+cd6GWNqEXaqTvOIi4Cu2UA9APSyJD3TiMemvlDdwVO9mcE5EsWDbZEHD6zGn2HxjXBFJbBW0Q1eop15z3IeE8bx8fA+h459gJeE2gOa/8ZahfTksvBpPuPFo1Nvz3OMLem8S07dKSlA+im6Tf3+Mvgp1oKFUjHV4Dk02lDm7dq5HMFu0ip79dKnzxMdDGRsH10TJECOOr3gEWDHeP4dcn9qbc5ypdHNVtCyoatiu1nG2+mVGQNV0Mfd1U2HNjew80gm6aCMgKiwWRvUZ4PA8eptE2YiekVDlA7ilrU1FDTEs9cZqL9SOYc95XD1QJ5Stnrd2x3sEuTajWx4uSP1qYWp8Qax3pPGpyFBN3RWsmSfbeNrH8vXRGMvQ/M9bmL6vGz1S91MT81BckVawaMAO//d5zFv6vqC1nbs9geRRAQ9gTVdT/mh
 af9zEQc2
 idxigBfVyt0Ok4bTgPWv/wm/QFCVy8CFLfL9OcyWSeXu+qYyemUc7e/4JzS59E+X+BJ7LFhjsd0WuorezjIubpMes7z2IxXuF36NdKiMawZxfZ5X6CZhj/NmffDuvaHp8akB3WpZ6AeSS5DKLloP+pJDBGtXWo2p1K0qT0I9cZ8INtcD1vjvAfplRsEMKsVouYClDzNeJenMFKJsykPfsaMB7XJqos/xUfF8BuaTSsIhZzlraCu2Nxl+rjhup946Tf17LrCKTRlvZFh5dM5kBJj87lL1SkEbPV5A4eJf4ryHMHbv/utvq7GdA2I9/ZnyTllpl5MKIvf0qV3y8S8CTdCMvtf/0pREOEcvtVNBVb4B8ZvYOYBQg9e0yslHnG7VXzIP2AvRr3x/rkHF8Llps83zU/Q2oCgnAbOTe0c+wmAi6xLy2jxqI78pgQ/pnL8NNvsZrjFwB3ed6WptPhn1wIT38v3ScR/gebfPMqrWsGuQXZgvI2TNBAoZH1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 03:06:42PM -0400, Zi Yan wrote:
> READ_ONLY_THP_FOR_FS is no longer present, remove related comment.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>

Acked-by: David Sterba <dsterba@suse.com>

