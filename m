Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A91DFFF512E
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 17:33:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DA766B0089; Tue,  7 Apr 2026 13:33:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08B486B008A; Tue,  7 Apr 2026 13:33:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE3516B008C; Tue,  7 Apr 2026 13:33:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E00216B0089
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 13:33:48 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 87C1A1A091C
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 17:33:48 +0000 (UTC)
X-FDA: 84632457336.22.109D9D4
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9F1C2C0014
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 17:33:46 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Qu1k2LWm;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775583226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iMPEJ4PSjOhLfHG2aITDvdb8l6v5fds0USOpCE6Wu38=;
	b=IWAsL+l8lbtzp3AoDChq3Sq58zVCwLAaX1p+BQQcTalX5FrjDr1UYGU5B9hUEH8UwpJTLv
	xL7g+GmNlUnSUVKcTqyLvgXvpfIVkBI2uRI1QtQC3G0FyHw9hBLwPiX8rR+yN2MV7n1rAM
	gsEG39VHrmhr9HbmSW4paf+jWc4/bKU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775583226; a=rsa-sha256;
	cv=none;
	b=6qlejmxCIzMUbMVLHvloypdTFQQpRBs6NFgF49KX4PMHzrvn+nBsKg8X6+o39UvmMmpmFt
	vwtAB3eDE4zZz0yhYTIMck3OBqEnyKR9mhhx5wPMT3fIlhPXbfwOVlCHN7tts0SEvtD81k
	CYhRj6n7iWoZNemVbU/UdIEnHnxqwI4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Qu1k2LWm;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-8d4f78fc9f6so461283585a.3
        for <linux-mm@kvack.org>; Tue, 07 Apr 2026 10:33:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1775583226; x=1776188026; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iMPEJ4PSjOhLfHG2aITDvdb8l6v5fds0USOpCE6Wu38=;
        b=Qu1k2LWmVzF9DQ2YbvBaMKymIO8Ul7nOLDhaO3tM8phAAgLeFORkISgU6By1wuCYmD
         Jy+kEsoiC1tA1zZk1pE6fxO8cWFd+elQ2r4UzfI7Gv6y/bcY20wut01mSRUDgPhQKgoz
         CfN4G6ti6Btq+X/ZYax9OFXZC94FNiAnPuGkAKKUIv4QTp3pQDuy7gGpxzXSNLdjyoC+
         zpVws619NryW6vAazUARveKsMAV+OvkDSpnsBrTyQLEKtLE9TlD/+Z1Wn9du9pmBWk+D
         t4x/O5nBekKuGZtT6h7bL9vyUzXV11erOTznt+VrCWghHCYYdoPul/s0tYJTzpLCDW29
         qOGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775583226; x=1776188026;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iMPEJ4PSjOhLfHG2aITDvdb8l6v5fds0USOpCE6Wu38=;
        b=FPLlqwMzsmZh1BVLL9SkBkvLTgD1q1h3KbuYIHjxXPjFZjLaLuvXgYvnltIiRNDNAp
         G0pBKoRN2PZ5l/8BtS9P20d1CPrQ3jMDgRicRO54KUOO9jQKStp3QlrzkkRJshUQqNyr
         M6hK3dilZq4DhvGNX3MLdkex+hg8sfYnRX8V6QDSJ8uWRpe24k7FHt+xC08fe7GrtwUg
         3rxT/Ze17dpUImqM8d+vvwVN/lr5gmquBejII05ewsWiYZy8vO3IH19gstmeCFSuTMAN
         +0GJy/nWmZEqA5wXHTGOKsX3miSNBiW5Zjotqzkbl8N4FqRlParHWEHqRHLg2EBepHnR
         3zdw==
X-Forwarded-Encrypted: i=1; AJvYcCVEWn3cgBpe6tJnB3ybecuk9rG7NAn/WHEI8C2HGC4hS4IyOUWOX7sb8VkVXmSVWK798CKq9Y9TGg==@kvack.org
X-Gm-Message-State: AOJu0Ywki9PWm6ysmyzZ3XcbhWQ1Qtx+kA+YbP53gtmUg+LJCbFyAexM
	atxckOKwt/YB9ggCY3zz7kM5KqUd/kFzdMo/xcSxFH0zXI2HY2FqlULVURzhokPLAI/E0L/cj05
	GUIrf
X-Gm-Gg: AeBDies7JN/HeshI3revc0A2s8D/Q0kEddbxOok7K6qu89vdMKvu+iYpYh2Gn3dpoyU
	pl2mnjnRkEwRn4NDENYu6AX/cuG6a1TGFq62nNOsHt3rkZ6aCvIhmZt9p8bVLgAute0Mz5ZZkyd
	3wox/TqFCqGPBNV/z/wdqfwG62FahIt4WAHBSzmCnMoz9kkU0lhurKkWCQQPFwpOX8IErfV2qbh
	/3Dstu8ls2GOnleKel4J3avWKZy7rLDmvfLcSOz5vAe0FhjCcy69KZ4jchJi+OCaEt079nKLxuU
	Wjt/I9rH9ox7XRYxk2HACVEcacv29ghyo1XZwUcsGX9zc2pCqvH9MrU2GwcyhnGr/XN3lhcKMcI
	PuAiNuBclkkIaT+wKMbImOdfgFNaYQwqh+Z4g3nW2RQ0QWx137ZKA0D9FWSdyCSTW7umlU5DILi
	xxrMpNP/Gl6N8KfGPLTtUNusEcb1mZiHLyO4XsDZ5+V0NSrbMhb8GjH3xp3dhwYjulRuDgB8hBZ
	lirn0um7QRk
X-Received: by 2002:a05:620a:7108:b0:8d7:2745:6462 with SMTP id af79cd13be357-8d727457900mr1390116585a.38.1775583225568;
        Tue, 07 Apr 2026 10:33:45 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-71-191-243-150.washdc.fios.verizon.net. [71.191.243.150])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8d6339bc438sm796063485a.26.2026.04.07.10.33.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2026 10:33:44 -0700 (PDT)
Date: Tue, 7 Apr 2026 13:33:43 -0400
From: Gregory Price <gourry@gourry.net>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jackie Liu <liu.yun@linux.dev>,
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/mempolicy: Fix weighted interleave auto sysfs name
Message-ID: <adU_9_J74OO9bUhz@gourry-fedora-PF4VCD3F>
References: <adU6MOCggHJ3A-n8@gourry-fedora-PF4VCD3F>
 <20260407172350.699577-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260407172350.699577-1-joshua.hahnjy@gmail.com>
X-Rspamd-Queue-Id: 9F1C2C0014
X-Stat-Signature: we5rs5q3hf4ogsj6oqgsbhjpntse9agp
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775583226-893281
X-HE-Meta: U2FsdGVkX18fNt5lT1JMz389bQje2cUupCVRbDcUb0CL2l9BnBGbpbZkrtV/SEPl4ADgZRfvkhV/0NAn2uSG/c6O2xfPj+QO9pR1ppQREbEHp1zCcz0aFY/cyR7b9XOVZA0BOl22QV/wWKVwVu7UcfdS2+9PO7Ks4Eli3dDDrF5V9IRTw0GiOHNf44nLxuTTHjssI88pVj+9mTfmW4mkaj4MnsPMjSwBzeryFWy4X9s6fCxjqqMlImdfsfboOdrv0ZsWQb16toHb1YDRU1Uuu4sAloBrNTLk8C0/uxtokzg+R30uuuX8D3LnLIWIOqlyBDoSuJkaFgtVtH+mNpCBVmITtVbATKveTLthzF2GUPbNSw43gNJKjC2VsN5F02b82k7k/NdI7pdVp3j0CXroAvT4QXQueqlzaB9MhP2ecteq7jWuvuvSno8PRbdVyycd+sUpJYVBc7HrilMzK5HENuzvaMi291xf4S4ymuZUowW7F2mbmOwEn223DUIhqw15WSAcG/YvpgFKj9IBHShHBRke8M2g04pH6H8Anbt1Am8A59tpkIOKkC+wc8U6VHcwzJsBgnDctvTyrMcRgw29ob5z/BbkBdal5bE28Bv4/jAs/r9T0XvPIKw/+6ctRtqF8KaPJtaP15fc9zkebzVf6AeXR9o3yIerNCGBEQ1NJaERq05A36jJAP9dWZb9zsam3Mx4BFHE+8Dlb5Cv0LGZtJHZrGrG2eymERj2gOjIsG4s1fRRSkYzvMwXmRZT1VwaMSSpbQpn4p5mHMVVajrOimppAdmF2M7YN4WRbYlCrs93ig9HzLHu4rAGQ0XMvXPJRiyGhHinMmjWZowaN1s9Ag/tWOz5O39K6E7TgffsVAFgJn7/Zy18wP2kuC3/V7IotbOw7g69PfNtbCAeZEEBGAO7zOcWk4v0jhwWM6netXN7PeAMKIsNKpZsS4xwvNGiU08x6cIvNKcCaKdzLPg
 7G6ku74U
 n9zv7HUTu60r02rVm8qsh1MB7Zkbtd7CWENZE2SWWJtpEoIMdYpaKyhi7v2VelncLjWIlQ/O9llOW4MyALCnOuIiD9ZM02fK9hW9vz8SE7mccb73qBzfKx4ts5U8Qlp/EREVSAAh97KEnDQ1HH8OHoGSlIZ2A2i/34WJNTF+JAYA4pblBh9+SIPOddbsS8NYSCQOrdEfW0QjdtDnyC8Vf5hkb74v6ANcu1EQkmoPolCriaxnlULM6ZmQ8Juh9gYBD0OsHEWXXnmG2eYdweSm1Y2jYVUo1nUXIRsV2sQdlPXa1q6JrV/+zVx+NtYuw4tu2AYz03ttpjhiRP1ADM4j2oDncLco+qecwkTo/dq+dvfPzRcT3TT9nMJ7YWrnND6YI7mg8HLTowXvHSzmyvkah5u41sYtDuIcRhr/mmyva3mVotTZ369BvXjIHj9zzB7RBNcCwsrRJQPvlcWQ73NRiR4tyThU/ZedHeTOD79CB50BnQ04=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 07, 2026 at 10:23:50AM -0700, Joshua Hahn wrote:
> On Tue, 7 Apr 2026 13:09:04 -0400 Gregory Price <gourry@gourry.net> wrote:
> 
> > > Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> > 
> > Maybe - 
> > 
> > Fixes: 2fb6915fa22d ("compiler_types.h: add "auto" as a macro for "__auto_type"")
> 
> I thought about adding a Fixes tag, decided against it because it's
> purely cosmetic.
> 
> ... but now that I think about it, I think this could break some workflows
> for users who have automated writing to the auto sysfs file.
>

Yes, it broke userland software depending on that symbol being there
(which, hopefully, is very little at this point in time).

> Maybe I should add a fixes tag for the patch that introduced the 
> sysfs file instead? That is,
> 
> Fixes: e341f9c3c841 ("mm/mempolicy: Weighted Interleave Auto-tuning")
>

The original commit introduced 'auto' and the compiler_types.h commit
modified that to "__auto_type".  The latter broke userland so that's the
right commit to mark for Fixes.

~Gregory

