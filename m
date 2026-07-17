Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BDDAC44512
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 03:09:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E019B6B00A2; Thu, 16 Jul 2026 23:08:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB23B6B00A3; Thu, 16 Jul 2026 23:08:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA34E6B00A4; Thu, 16 Jul 2026 23:08:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9DC836B00A2
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 23:08:58 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 14FA6403F6
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 03:08:58 +0000 (UTC)
X-FDA: 84996786756.21.464D16B
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2DBDF180004
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 03:08:56 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=V69SB+7N;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of linkl@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=linkl@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784257736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xkE7Fo4sqZ/86+n7TYPmzgcfuvqX35lIQ9Nzu1Gipdo=;
	b=ZVo1lYmMmkVHn3Oe3f46E/jDea27u/uDz9S5wuczcTmUJi+0k00YpfHuteWuaKJrreixoI
	SrrKLoI8uwh+zc/bjzBxvKGIjKa4z+ysugFmKjfjuHubECAU9w6FVsQiOohYVkFRIyzi/g
	uJH9ZeJEKIWd/AfS9ncdZeYT9ue8XQM=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=V69SB+7N;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of linkl@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=linkl@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784257736;
	b=v5vr2Pfv7T3Rtaynz+zAFfeM+9aKVoW15Nn2RvP/tjuoeHOfupeEZEoKzd8GqDqy6wXaxe
	lwSGd/8NFrYVzjureVBTGcChriU41l/5lDITh/KyPYz8gm+P+++fZJVt0VrblWzeVqoOeA
	3AMFOYodYDKWDDE8T9lR7jiQ4MPZZ/Y=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-51c10e86e52so239271cf.1
        for <linux-mm@kvack.org>; Thu, 16 Jul 2026 20:08:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784257735; cv=none;
        d=google.com; s=arc-20260327;
        b=jE8AMukF3w+iEQzk5p3PmS6viuPoZ/V0/YpEIUq9ZbyaYURuDTsZsw/Ch0dBkNHyuu
         z3eBCgPZOmLQ799xFoV+zrDe9tEtXoi+K1qL+9cFbM2mLYz/qcfO7Vz+G5B+NUN+ch2p
         eyZcG8V7+JvhOjIvV9dxO8mW0VVvgfE7Rxfpd3NtQspGOdCpoPtEGS9jNT+g4Q0x/EFM
         4h0MyD/IdMqbGvdQDlERRJmyiHtEPwDOeuE4FvfAFtzVvg3nA6jUaI2yZVgYj7o80bUw
         uGy48JUdYMhJC8/1mxNjqBtwNzuA+AFqzi2/91Xrq0wy9ld1LmhmxgAc+5XomdYYoTw+
         r1zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=xkE7Fo4sqZ/86+n7TYPmzgcfuvqX35lIQ9Nzu1Gipdo=;
        fh=ckqK2sUuTy2nUOpHwXDV7vTwH7kBZ6LcFkQnpsIPqpo=;
        b=RH3WvWIpQiNm5wUbcCDyYlfppixYZ1y+zOENjPj7TU79Y3xCc124B8w+z14FaWY2Xk
         z0CgnYpLU3CcNj5q0CwmAALNUjKPEqmf99Vp4saxUOJ5/W8fS1jckvcFF5WuiQqSxWgx
         A9l57R8rqChVhPXrAsEo8mBvh+0qpHxHR5uszBgpCmZArEwYJUSBJcst8rjgMM/gNLPe
         jetnEM9mJzmbymxWdo9dDiRsZq/Q+B/6iTinxgjZuDWTxIuDGtHeJKkJYtM5bhRdkdhf
         jZjrOxY1nybejceefXZDXYemQDR4AuOktj2b1IsAVxSyPHXImAKYU9LODcQxq0oQDxN3
         TDsg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784257735; x=1784862535; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xkE7Fo4sqZ/86+n7TYPmzgcfuvqX35lIQ9Nzu1Gipdo=;
        b=V69SB+7NEx0JBwenwZISuJCJDTDE1UE0uXG5I/ig6cdRVpyABS+zDceVlITHR2TuBA
         lOTq04p00K6A6eqNGjdydTjSQvSQ9+sgwHMg/G5N2rFdTplz0bBi+xPPvBagVEdmL/xS
         A1d7Y2HcciyttdGEg+6ozQSxf7qMzcElzY36NBS+99ZeFBdxv4SFzfCtL/as++kYfR2u
         AAG3TVsgUxVY8aFzxEPVkRsE6qE44PbG2gLMPJEw1NdUb5kwC50bDug0H3k+r4j0+tx5
         +NOIRD/bDVczNPhm5331LIZP/mqcAnRjFZBopLzSUBLk15Dk3AKLfRlrQdpwj/0lJacT
         sumA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784257735; x=1784862535;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=xkE7Fo4sqZ/86+n7TYPmzgcfuvqX35lIQ9Nzu1Gipdo=;
        b=aZJhbHGEF85mhanOBAJYqnj82ZO8jpe7zvGHjQlQCN20szbw+Cy8UfspKuB7N4ZWV2
         E7y1/aLq37HvMd9ccHj9hzN/Z10c96N/ujXqvemaMdMF975j8X+2Cls5Gl1RENN0gozk
         e3XIdDO3nKAfgCYGG3CRoA72zINhtDuwP2Y/TxgWsySF/yAiUj7XiK2NIR9mstA6dyIR
         64cwji8V9NcOo1g1OHxvL2U3nNVtLR0n5c0YYu/UxQyICs8OvidCJCUhjLcKs4fmB72q
         QVT2uNLqthh2NfUGWX62tjQY7dEBEqoPFTv8gmoFRbpeZckZFlmK5GxGTXNKumpmwyiw
         Kf+Q==
X-Forwarded-Encrypted: i=1; AHgh+RpiVqKE0rkw/xDGdRXZINGKaKzEMk7tJxVP5MaOobuY+xAymOvaB1Mf06caEDqydyuI+PZHzZW/wg==@kvack.org
X-Gm-Message-State: AOJu0YwhlIqNnGQvzH04ExckfNbtP5ncnY32U32cm1HHsfaTlA2DOIdh
	YNuc3+Xf36u172Tpo1UPzxOomeQSiBU186m/0U6j5kYgQKTJlhOAdwjKS8sH0JYPSeF4An2KFcF
	jIklqWl7eOjpt4zDnF4q7pZUcPiyYGF4uKnkYw2gB
X-Gm-Gg: AfdE7cnLSeASvXaTTA8TDBLyTIq/tNKtkUzUKCR3JMyPxrsoTXarJWC/MTYTKkRBGr9
	u4JWTuSNUaf8NoyB4fuxHp83K6g6TQGuNS/ElFenPeOHRYNbqp3IoRNcWKhQ88u/6Zowjd5JoVg
	R1FA/5dl3jeodmbDa+3Fuvcfy5l+FTv6xpgEtiv+5Un58CJ9S95GcJRAj5IOB7cVFavwa6iBzeq
	s5d1epdkBx9lJnz9YYclpbz9MklJUvfrW3zAa0DVzDmy7Po5uGZj1e0odkgolkFQwFJbyfFD+Z6
	jjMlht1XR8cnOojQ
X-Received: by 2002:a05:622a:a908:b0:516:d570:82c0 with SMTP id
 d75a77b69052e-520fee19f7fmr3120471cf.15.1784257734125; Thu, 16 Jul 2026
 20:08:54 -0700 (PDT)
MIME-Version: 1.0
References: <20260717002311.681748-1-linkl@google.com> <20260717002311.681748-3-linkl@google.com>
In-Reply-To: <20260717002311.681748-3-linkl@google.com>
From: Link Lin <linkl@google.com>
Date: Thu, 16 Jul 2026 20:08:42 -0700
X-Gm-Features: AUfX_mxICqJHmAVK8TinFxnPQuIwu8KNDwpqoJsVqWM4NDLatLe37O_LMt6bETw
Message-ID: <CALUx4KTH4-D9ZpTrEikHajp=R2VxXqLACsJC1aOhX_W8+TApAg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] virtio_balloon: avoid shrinker execution during PM suspend
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	"Michael S . Tsirkin" <mst@redhat.com>, David Hildenbrand <david@kernel.org>
Cc: virtualization@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, prasin@google.com, rientjes@google.com, 
	duenwen@google.com, jasowang@redhat.com, xuanzhuo@linux.alibaba.com, 
	Ammar Faizi <ammarfaizi2@openresty.com>, jiaqiyan@google.com, ahwilkins@google.com, 
	Greg Thelen <gthelen@google.com>, Alexander Duyck <alexander.duyck@gmail.com>, jthoughton@google.com, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2DBDF180004
X-Stat-Signature: 86818unk6795o548wa8ym4ngcr7snf3f
X-HE-Tag: 1784257736-970901
X-HE-Meta: U2FsdGVkX1/A81vEfb7ZKsxZ5ODstPGIiKIfACt4eye8FDMPT7rm1EefeMlYad4kMKWNKy7rW7E9jtuik8DjrxGtRpFyTAYtQ29bgPDViJBWyNpm1X5iMQzHpysiXQptW+04AoxmLrb+mDHxzTdvPYNBIh2wqkOe4v7T/HLQpnAnKlTgMSv7V9WEJmgn7kX+pbD9beKTaQ5goZo5wEg2SzHNjysXV2VY2WfI8xHRLOzrMaJ6OjjDNZQlZPM9XZiozMXTkpgiJt4PIMf1WRTZSXCPgFeFSkaG7DT8IpTQQhLnwYLz1FdVlIQft4xQDaR/CYasBMaG8I3cgB3FtYbqnE2yY8q+W3n7ImGl0QVW3WK0uSYsu9FntzhTN4acBluk+ymndQ4P7VfjNpsq1Ap7TZsiJrTktb3qbsurkAQ2R6xy+ynyiIYFAmUaY+11JhLP/DCbtlPUunZLN0Y/RxWhWsgbwmJygbLYkuKZQQvyNrjArjnjK7L7+fapm25PTl2uLW9xNhIqaLT//Tm+7JjvrQhIPvKJhFuy54loZvNTeXf4H9SpL0SZN4CphbG9mg4trJf8MR42lXyh54QiZjh2S/kac3r41rWQO2rJBUG5P6NypdI4VR2c3/YPqR/3H3pgZAyrm69rCO95bhjVyFctdbEhciTB0mz9YzNVikH++oVRpFG7O96Sqj0lN5L3LBFb0uDSwRV8HxLvM8GzSLQ6UIImixULmJ3Oz6QKHHbJmFinZ9+qDk/zJjk5iQRz4uwX0DUISo+RI+d/pLbks5CApTzl/vwGvolmF1IAxCY6t5+z85bGDq19HEgYAbyQLYW+npwPMN4DkjbOMKULFohYOb+UIKsGvEKxty2uLuRePG/q3XxAHN6OBHyGiGlpm9DvAQ0bkTOCgokj+I/tHBPxvr/z383obiieUv0ybc0f9iXwwPxbZIr5ALhcgKRa/2mPnsHviP330cmq4q0Vg3+
 ogY1O0xB
 38Xvd8Mzjp/qPyBKbxsewJjwC2UhVP1Q7+HPAPV1cOeeNbQvvVwF00UjApOVv1d0/ipFeUey6r1ESmuaqk6L4FSVONEjMKntl+9xyMKRhPLkzk+FjIJD6QF0WkgsUHDRKhQegdCx3cveV4L8IMX2Notu5IZmlEB7zBMRBcz+xfcOa9Atj3KIdp872hPt7iOcEHSym84KLMemSHfGy9EuzjL6Tex0aJU2Yz9AB8vrH2qtP8/oybCSQPR9SbuCAdJpNOeIWJeS59PP2SE88CHziqZyF8o/T6jCgLzi5aCcxD7Sv7lNXLoLjXECU15Cl6zDR0kbgmUdANk3nlRdCRVQn7JUrCvoTfonOlpKmcj0dbiaQahxFuWk5LdCwi37/6AQHCqs5hiDQkRBvpoF5AV9OB/ShvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 16, 2026 at 5:24 PM Link Lin <linkl@google.com> wrote:
>
> During PM freeze (e.g. S4 hibernation), virtballoon_freeze() calls
> remove_common() which resets the virtio device and deletes all virtqueues.
> However, the balloon shrinker remains registered with core MM.
>
> If memory pressure occurs during S4 hibernation image creation/saving, MM
> invokes virtio_balloon_shrinker_scan(), which attempts to reclaim free
> pages. Although return_free_pages_to_mm() only frees pages back to MM,
> reclaiming free pages under memory pressure can trigger page reporting
> which might access the deleted reporting virtqueue if it is not yet
> frozen, or interact with other parts of the driver in a teardown state.
>
> Avoid this by adding a `suspended` flag to `struct virtio_balloon`. Set
> this flag to true in virtballoon_freeze() and false in
> virtballoon_restore(). Check this flag in both shrinker callbacks (scan
> and count) and return 0 if the device is suspended, preventing any
> shrinker execution while virtqueues are deleted. Wrap the lockless reads
> in READ_ONCE() and writes in WRITE_ONCE() to prevent compiler
> optimization issues and KCSAN data race warnings.
>
> Fixes: 71019de8219b ("virtio_balloon: Add free page hinting support")
> Cc: stable@vger.kernel.org
> Acked-by: David Rientjes <rientjes@google.com>
> Signed-off-by: Link Lin <linkl@google.com>

Apologies, I missed adding a tag for the feedback that led to the
TOCTOU locking fix in this patch.

Maintainers, if this series is applied, could you please add the following?
Suggested-by: James Houghton <jthoughton@google.com>

(I will be sure to include it if a v3 is otherwise required).

