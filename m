Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DC5AC9830D
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 22:09:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C5FF6B008C; Wed, 23 Sep 2026 18:09:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 276766B0092; Wed, 23 Sep 2026 18:09:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B47D6B0093; Wed, 23 Sep 2026 18:09:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E3A036B008C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 18:09:54 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6341316016F
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 22:09:54 +0000 (UTC)
X-FDA: 85246420308.13.D02EC37
Received: from mail-qv2-f12.google.com (mail-qv2-f12.google.com [74.125.230.140])
	by imf25.hostedemail.com (Postfix) with ESMTP id A8F0CA000B
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 22:09:52 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=BJB7Leo8;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.140 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790201392;
	b=zCO/nHFfdOGN+GNcUxWCyDj/bsbhQeQmd1SZUssAxK2zR/I18gytkRh53OnH2KkVPalTkl
	7cf78eyIIo9Fe0epNbsVtpog36bY3c39xg00+B+SsPKkOGe938YdHpIBF0Zhljd6vnjn7O
	jasZeKraUcAs0oFAE53VH/5+BuvpXfc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=BJB7Leo8;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.140 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790201392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K1Hvo7RTbP2R7EwaTKGv+PaU0aoOQ9FZzhpnXlX0iSg=;
	b=nnOhOQrXhq1vo0Chsi0bCS+rMZJeUmer9kyAnSBEvUfVbgJTlmIqmiKe2MdmiAwR3ILVih
	Z0GO00rLov0wopxsHGIjKn5IPpvU4rKgxH0HPP2c9G/YKpNdUK/bnuKwqXd+bdVMrCHCbD
	OGOH8zBUosiD81sYfhxKyZ3gHaJRWYo=
Received: by mail-qv2-f12.google.com with SMTP id 6a1803df08f44-910537b51a0so10435676d6.3
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790201392; x=1790806192; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=K1Hvo7RTbP2R7EwaTKGv+PaU0aoOQ9FZzhpnXlX0iSg=;
        b=BJB7Leo8NVj6IIEA337jq9t5xIk4X5HSehAlfNbQRB+xxm31182Ft4oqEBcwWl7QF7
         dN9+LBGBixat1emJseZT2SQro38iwTjYmrnEt+u73uB1csLEnLBXAHeuxTl/q8a+irKz
         EyW0P14HjHdX6hOgTZyrcRnmEwG4B0HQZj0BKzx1AE6oIdn02/bG+JCOryYTC5BPYOia
         6MaAg8PpNMfZw/TL8yJLWpJS6eX7PSs+SEUzlSMH2piB4NR2TAsJJSWlBpNNKbk1AXAO
         79PvT4/DjLn6dELMa3gn9+BKxX/87HqqjNjI6cznAuOdVmIVKS32zyOX/WKNgn+Gzv5u
         az/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790201392; x=1790806192;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=K1Hvo7RTbP2R7EwaTKGv+PaU0aoOQ9FZzhpnXlX0iSg=;
        b=sAe7V0D75XFNNZ+3R6USXpjXPPTrSZUA7bnfmoI72PnGcgh+HIX768AsQNT+CfBz+6
         NsuRjH6BQazNk0qeuZfrqECimb6M28PDMUa6krJgRuhW5QGV4rxmQFuLMmMHkfzad2tV
         k0HrX81qWhf4xn9gOO+a0LbAOgt+2ale8lE4SyjnxK/HohD3fP4vKeXCBKKG29AfFq2d
         NdZxSIhgZJhyUsLoEGsYbQ3luPLKv1rKA9/b//pV/2uU5o1aC38f4jN2sHLTZOQ+5uPH
         Tz9do9Kxn6bbiVRxO6efjRoLmNO1TPyDpOKGsEGf0fIUDRCNhuBA9OWvJSOtevyX2IIC
         gULA==
X-Gm-Message-State: AFuF++lpwd3kDR7qADOLgZKFJpgnDy09hHMHd/9GUn8CaULkAGzNMpX4
	jRtTMyawgP/+o8UKLyK+YmyCfE8KT/7C7z+ztBns2MdONmc/J8rphKQD3jNCvYnbG7g=
X-Gm-Gg: AYBFou3DDoVf3CM1Dx8k0vizZN3/8sUqhEQmjgmxySkCI4Kj3uPNt5+U5l6J0RTOHXL
	Bj+5uqHQowtjYjccBrWwRU+3a1b0qlGopsOh4IXwWu7gAnW/5qqqWF1JlcUf7+QCX/Lkt/STGIE
	qiHeMofCqHN7rTSQHlkxMXwmazrW7Nc7DyhZvqyaNYBr0qRVxd5Abrb1FLdr6w/cw7RPEqBl50b
	YvGjkvMoWtskfmDSurPRM52kkeGXFKTI3HQZqrHJdAoH8Ll9x8uXj0zDU8gfW4QgdpWNrTnA8qY
	fYogs7taorib39vH/sjXxHlkYOmBSziJ4zvk9aX5jqzGdmZ42keC2OGf7K4YCKGBU9A6J+gs1Ur
	aVegem5AceSmo61OdVFxXVki6bpr5RVqCm5FI9yb3fICb3Rv0tA/A4BTpv8UD3sksv0+irQBvBO
	ZpTuM/RSm9otPc6nqjULYTfgUOSa+ig12gcQB/b3Or2mIhY+2qC9I5zDb/rBsUC7e1hfYM1Lr9k
	7kl7/LlePmlTqLvU9IFyBa4/wyAFy0Krs3uQFywD988DZGLQ1fg4R+BTx7ZgEZuKZg=
X-Received: by 2002:a05:6214:3282:b0:912:517b:9753 with SMTP id 6a1803df08f44-9141e966f4dmr9008456d6.45.1790201391865;
        Wed, 23 Sep 2026 15:09:51 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9141e217944sm3890176d6.9.2026.09.23.15.09.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 15:09:51 -0700 (PDT)
Date: Wed, 23 Sep 2026 18:09:49 -0400
From: Gregory Price <gourry@gourry.net>
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, kernel-team@meta.com, jack@suse.cz, akpm@linux-foundation.org, 
	david@kernel.org, ziy@nvidia.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	ying.huang@linux.alibaba.com, vbabka@kernel.org, surenb@google.com, mhocko@suse.com, 
	brendan.jackman@linux.dev, hannes@cmpxchg.org
Subject: Re: [RFC PATCH 0/6] mm: pass alloc_flags through folio, filemap, and
 bulk allocators
Message-ID: <arRM9qUFLfP04YUB@gourry-fedora-PF4VCD3F>
References: <20260923211041.3127588-1-gourry@gourry.net>
 <arRHr05gy_eu4WVA@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arRHr05gy_eu4WVA@casper.infradead.org>
X-Rspamd-Server: rspam06
X-Stat-Signature: 9po9x3mg6jfu9y4hoa7nm1hbx3ztwy9m
X-Rspam-User: 
X-Rspamd-Queue-Id: A8F0CA000B
X-HE-Tag: 1790201392-603049
X-HE-Meta: U2FsdGVkX18q6yNMXNn8Nd0GUPnMagz2c1DiDsp6zbstBeoddEZ94NF8aXOkW/42vbPfW7Akmvt9QehqG6yYAZ3it2d5oYnB70vln9UtAy/cM59x+D/T2/yZ4dAOg6AKk8DPz3H8qv9pqVPwIsgLLom+u/OFwtsaz7x8nnf+cdTw9YGpqGJgMRt0Zm4T6l2+LOlk07HZZxsLJBBAMAEXhUV0oiURYYK8UIziqr7FMU2kb1Ct0e86YvpAkytgdAKaAnsFJb4DxJfQdbS0R5BPh211P5/p0Fw6miv/Tkr+Z9V2k9wl50D28y2wKBbUZUNTOgZ0KrC/AVNi5Q2S5CL+GGTjbYI7JE2GLb1+Df2kQr1h5z5MKIit4+pvcF39s6HuU5a8PZ7gkRPk6eeKfOQcmQ7HF/M02M6KLcTeDfeSHCVuxhi0RCF3359tv8BOgZ5tdoOInLLvkfKueWRnKnA5juqa0Mg4tyL/oovYbRrTaIf+YbIzfccFk64SjMuZrgEDbW5IFX1woUX6wTbV7W2yTrAni0Iy5BPTyRi3V74QgtuwUyv8I+Mo3aY9yiKYOKYLZcBo8TAok+GtHpCANG6yoFSHNfGWfYYV6h76JT32O3xjAX+8k7ahCG6UIB+StmfiBkwmPWi5m/7ZQgdgKMOI/3HomMM+4uGYTfxc8DekWQMNw5/J5gTMjJBtu+6Zuu4R4ZY5zx2VC3SDmA/hPnoVIfbq2uzSq59hgNRMqBMvGn/qCLVFOpPyEV83cE9OeER3OluccDIAEd5Hdg4UP1j4ur3MLOJnAgRBwE6NCk4o8mIrg6+BCtVXFeDy7MEXXaz79Ig8OZ5zX6Gewn/qG9Q9YPof+7eh23NYjXqDXsfKadrogHNSufNTUrOqrTkJJHjn01c1SWAnRT7riB3zjDFo6/9RobVmibOBRssWNUdc/k3oxew/KnA5Vxq6Hme2TRnb5LHTqEAEW4zFyHBi5CJ
 lL+EzVW7
 LWpBKTgZ02ofg/8qFa0sfcvW6pQZt9baRMN4qyn1Pe9ev75usWpJFjrmGbXsdAJZ8/VI4stOzV2+TYV9E8Qd3zpKnyVWvHOvGfCg9vnxpKkxsSTRHNR0FsT8w4nsH5hyr7fssfhva8JgN1PpYbTCmQr9MJuon+B25KhOveI34Hex4RvogRTWr3Yzmn+g5IJv1OP45zc8quKcictzLRpyosM8lh8rcQ5Ii6bCdrlmqvDsKuLW2QJipA22ejuWAxfL/QWzy8Wa9zAsiwt1WCuuBTmIFfQshOBQt9FsQUL5ciB8PNwfxG0pMGtMWygzU0fflI/sstKKPDVbK8aFl7J2g1tPBoUIs5rrZQ0Sv3Hssq2y4y11/tywcFHbNAZRMYg3GeC0rjxbd8TiSxM51kHQfQvsAJkpCFeziujD4+peN9SZATKkkvGrjOv7s/W2SjAQ0BT8X4+TQQ38j42zU+/4Ym1UjxW9YeOyEgzG3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 10:42:07PM +0100, Matthew Wilcox wrote:
> On Wed, Sep 23, 2026 at 05:10:34PM -0400, Gregory Price wrote:
> > The folio, filemap, and bulk allocation interfaces currently hard-code
> > ALLOC_DEFAULT before reaching the page allocator. Multiple MM series
> > need to select allocator behavior through these paths, so pulling these
> > changes out ahead helps both series avoid conflicts.
> 
> I really think this 'expose ALLOC flags' idea is wrong.

It is mm/ internal only - to be clear.

It's also already been partially exposed, this just brings the rest of
the interfaces with it.

There are use cases.  I initially only wanted to expose a zonelist
selection rather than alloc flags, but given ALLOC_UNMAPPED was
in-flight it seemed better not to propose different solutions when there
are existing possibilities.

I'm open to options.

~Gregory

