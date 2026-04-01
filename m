Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E262BD3515E
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 08:40:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 195AD6B0092; Wed,  1 Apr 2026 04:40:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11FAE6B0093; Wed,  1 Apr 2026 04:40:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F29AA6B0095; Wed,  1 Apr 2026 04:40:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DC85F6B0092
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 04:40:49 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 83745E064C
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 08:40:49 +0000 (UTC)
X-FDA: 84609341418.29.CF15F59
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9CA0814000E
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 08:40:47 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ijwG4NqN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775032847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B6iijgchx+dYS5ecxF7/o+lyVBYG7gkxzY2woIbsGAc=;
	b=jg9NrPLiguZoM3Mtd2hl+djP3tEwmBVAEbTJTiUZ+GpofRJRYzYMqG8A8RZFtyDPDGzSFi
	gSe7ZqUu15mWk2dIHXWm842dOpxCaX0PbPg+RWXNZNYzQ+XV0CewqlDZsTGKRBsvZKNjfW
	2oP7YroPmkZeLDJoMQQnHXUAhmgLOVc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775032847; a=rsa-sha256;
	cv=none;
	b=gAHcw7HDecuphrjijepT2vAY/nneDWHQx4AK6jtPVqbwumAf6vlbm3NwlPwe88aG6QWvP4
	uwaKZb1p7qFKHyKwexNR6QHo19RgCU5SRSrU5fXbNt+U7/0pz/E5btiFmxYxck9S/Weztt
	5syjwI6DCK39iguk1E+WyZqssjGQcd4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ijwG4NqN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-82c4b5dfe6cso2961041b3a.2
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 01:40:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775032846; x=1775637646; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B6iijgchx+dYS5ecxF7/o+lyVBYG7gkxzY2woIbsGAc=;
        b=ijwG4NqNZGMfIKeXGT8FEgLk2720LpdRY+3odn1tjyj26BvLYVUwUnbq7c8ugj4aNg
         imQId0+YzzJMMScg019nRFaEZo0ABB8m8uFoKg4AmkE6xyrtTk6bS7jmUsUOwjTAqyrJ
         SGtireJWR/75XIGxBzslfxIILo08pi/la+WaDFp2fQFyw3IqmsfLZbOoDfQ7ygr35gGk
         sb8QDmrj+0i7cDgy3dhrDtvFVQ1C7SiTXoAEiH+t3v84PHO9F+k0LChrW1ghDE2MjTxo
         oTko4jJ0aBKwdzW9aXoiSuqJ6fifo3JtSjXf27PaOdX7iv8ftYAle+OKkezzLk1B93HK
         Q5tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775032846; x=1775637646;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=B6iijgchx+dYS5ecxF7/o+lyVBYG7gkxzY2woIbsGAc=;
        b=e9hH/ucI/6kFI2+ugvgayYGvygns5v1+evWOKoHtlPI8pQgCvhr/rrxdnR1sEifdK3
         ZCyJTjctyosfmc7bBOk/zuKXQudnMpHodJTxdzVgIecIjD60GGWpQVVzFQTGmRp+NRkP
         CffVM+37jbPbkKGANQGWeYYKZNPTHM5LMvRHR/nfvOjKbIxZkWSAXhiWOY/SJAZzKHih
         MvQmuw8XtmITw2pzbglM3ho6KgHbBSfxj41vsbWW9/3HSACckGpNHed96ZxDOE39g121
         sxij4y2vXa+mKbk0RvgK95C2J/ZkWtWgniI5q0zvxFeIZ5AzBZX53uWkJFQyo7I75SEa
         +/9g==
X-Forwarded-Encrypted: i=1; AJvYcCWkDetzqdt8XjeAmM1uqY3Mz0koZE9STBmxpSKEijusQcSVyc0oknwoqX3lGpRt7AnlZcgfLZKvdQ==@kvack.org
X-Gm-Message-State: AOJu0YxnK12jscW5tEteNY1S6vB97MO0ZjWQQtpzfbX2uBQoRTj6Ar8y
	8tBAETxcvB/hYyNLSYl9u64N8W2mRImDxgrDgg5q7XXdw/SbIissExBe
X-Gm-Gg: ATEYQzxK73GNgRJoaFXhQ6aaSgAFoTHZC9BDcP/6g4qrTXow0dzMuggg1Z11WGZ5EEn
	Ugx1lOdmzcAHyX3rPBft+/V1x1uSmuXe5QJU6sFNpqp3/d+1WCLC6pZW1K3afzYhkQqJltLKouh
	WnWgcVb20raOvHO3FjRW3s729qjnPTAOa262qk7Wj0A3ABJqvQn9PCaB5otC9bGeBbx1VMglwqM
	V2GK8mH9M7V3Q8jCs7glPr22mYHFmUUMhL7/e/To6eSDjBwhVPKs3jUypYuifFs6v1vSx7NSxig
	nnKKtfb0j1OspxFph1Wrf6cSJXDYLElA1yMWfo7VSVbQNEO+DsU9w459y6mW/YtfV/ZCGtR3dC4
	NuODVJ9arX34e98pleO5z1p6FoD7BvY03mOLmMqfU337XJT19Hzzbz2vJd1huYfYAmwbLZA16kF
	vVk/5UilLAvtwfDJe/jj9cbmdaPEHcv8jVeOc4SO6uLTyrq2xXw0s=
X-Received: by 2002:a05:6a00:3c84:b0:82c:d7c4:4c6b with SMTP id d2e1a72fcca58-82ce88d81f8mr3317802b3a.11.1775032846289;
        Wed, 01 Apr 2026 01:40:46 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cd7d0410bsm5147718b3a.33.2026.04.01.01.40.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 01:40:45 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon: validate min_region_size to be power of 2
Date: Wed,  1 Apr 2026 16:40:45 +0800
Message-ID: <20260401084045.15473-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260401010157.86136-1-sj@kernel.org>
References: <20260401010157.86136-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9CA0814000E
X-Stat-Signature: q1szifuncs6kbsnrt5pf1kgp45zronii
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775032847-822077
X-HE-Meta: U2FsdGVkX18O0sge9KHOpyyNmb3EXYNfmdRMXLArg2BeY4v1pKydPjy9gR7DJ83x3lr+3kv5OqnsU3TSyesR/mC2xl9CW5NCpWtn2fbz/zYlWdTbOq9y4qL5Muje9FDbMiif7BGjhVD7hD0Xi4j71Kk3JC+wRFbYwyAdvvIjAUm8MbaPbsJ7iW0VXQiLlWi3bHxQv1Iddewn0in8qFu9mmkQc8TvWBvf2Kg/Sh3/svpL5167Ym0iP4w3DohTYKflW8DJzzcDIU6CbdDu0pYOGzz4amQxiYVyDq8Q58eqbwhALLiZVdR5hdEzwIUIJYUCIOfaK+wf8QCwKSpQtLRAHlqLfzTkjRKUIvYlU9z92TyKmAXV+MbfH4Eo+03J3p7z5THEnPn3okTr+aYt+9gbZS6ODPH7E2DqypWHCLvo8jHqi3ChBvlvZ9WuquTpzO3w6RkTLnVLkEttwAoZfKA+bsIcjnJLfblgjspuNpw5In5VsYq6fMuWRvtHY99zpv3e52Qkp+ZGtWPSaGUP4Kq2qL59XIj91qIq0F0ZWtel90odr2PhQ7bhbqQ32Yxx7QjTVmouz+89wX7Flga1o1ZoFSrL8YndRdmZjXF659KF7SZZ3VICY15w1dY1F2OcDCWoVip679BdtaaCZ8cuDBcG5H0DlMPofYtiam9Q/MvWiwBqxKg8Qg159HgvElAAiEXiaSXhPQ/zwzipGqkTnhN2HeUO9KC1LskDclI+itoHoer2j08RxFaqsaoG/Ap/DaHPQw31KZ35EyUfconvJoZts/Bo9oF03FrrJX+1gOtwGp6W6qkxwu9lZWNFZeXWFP8ieWbZX4a6vMV+d5gI4oN11GW/jiZmpuLXwcX/h2Z2uKMXTXqGAKPhviOPUH2kN2nLBgi4u8YOwqNmWAt2M1lmGEOmJDUqn232C4PlHokSAaIyMKnf1PllNXksfW55DSliIbHW1nmEl9vZneUBpeD
 oDtvwuES
 bHQ8xbIHhpRnIubSKO8LSu0ZF17km1yxvCzncpJPO+Lf3su++sLR7EHQ95QKJWpj+kJ2D12oiRKWz5CJgp/C0IVTNtj4RPjy7Bi2oMkwpcOg+y4T3bIDB0gSRutxOJb3I1jit5DFVaYLnLUF552TA1IUH58rjsH7KEaAPL+cQS/gCe3XER2GhbXAbybpq2bImW2UHJDkaKPqwdCcRwNyTb3ZqIEwJbCCyKLE4SHntyUr+jyYG8Aaa1IflxUGusdlXSN+i+qoBuQd6nUzqw0PCczH+41VLozClfYb/kPgwijvtXiMTIDHWiaWj0sd9gKjJtgHhyPVLSoVTYjqoeg9MzEgcYlRdg1KSZ37LxGi1RN8QsZFyCUf3lxYbFuGmpuAjEBHeWPWdpPjyOx0kIz4skZCCaB4vIfDB9TfdoGGkNg/4eDAg1mF5qEMPyG70/Jg837i+B8Yg/gqM3NoJrxdM0ORBMUcdIP55bZJDkS4dLn6/qDM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 31 Mar 2026 18:01:56 -0700 SeongJae Park <sj@kernel.org> wrote:

> On Tue, 31 Mar 2026 15:32:31 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> >
> > [...]
> Seems sashiko found an issue, and you are preparing the next revision, right?
> Assuming so, I will skip code review of this version.

Yes, I'm preparing the next revision.

> > 
> > Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
> > ---
> 
> Weren't there previous versions of this patch?  Could you please add changelog
> here, from the next version?

Thank you for reminding me. I will add a changelog at the comment area,
and add this to the commit messages.

    This patch is a follow-up to the discussion in [1], where we agreed
    that the validation should be done on min_region_sz rather than
    addr_unit.

    [1] https://lore.kernel.org/20260330233343.4083-1-sj@kernel.org

Best regards,
Rui Yan

