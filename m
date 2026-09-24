Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92E90C9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 11:36:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44B246B008C; Thu, 24 Sep 2026 07:36:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 422456B0092; Thu, 24 Sep 2026 07:36:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 338296B0093; Thu, 24 Sep 2026 07:36:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1848A6B008C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:36:32 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AD7F71C255B
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 11:36:26 +0000 (UTC)
X-FDA: 85248452772.25.05306E0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id D5121100007
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 11:36:24 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SAdcNDgW;
	spf=pass (imf14.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790249784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gBCCxxhbgyzAQXyG8s2K7ug1iU49Fp8q7jXyiLJq2Qs=;
	b=KaDj8KhVMzM3EE+0MNDgvPuQf5SGdAvZyu2D0OtAUQVsviSn8jIwPVMPWJ5B5M8Z5BXJzM
	O3omXMMRz7AjNI1q96d+bXnbp6AWDqgmbA5zF9TIVh/Wb2JT1fquqHb5Wlt244Zk/gSVaw
	xj1MB53NyUc8ss7Ktv9d2JKDSLf69Dc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790249784;
	b=tFmXaGCFUELeSoyrIpa4vyh54qSLq+eC5pj3N7QFgz9PqjsS1r3keXTFcDMxYJO4Eacvqo
	jQ/aMrgWpizPVbiYf91qVYszdbYnmiImHi0eVlwJGhD7e0dk9i5PS/sKKgMe6sCOT24ZuN
	hfsem90AvA9vLL4/JU4+FKbv8F7iYpQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SAdcNDgW;
	spf=pass (imf14.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5AFEA601EF
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 11:36:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 128E91F0089C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 11:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790249784;
	bh=gBCCxxhbgyzAQXyG8s2K7ug1iU49Fp8q7jXyiLJq2Qs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=SAdcNDgWRAPZDE0MNerQnfAmAz0638kUWrsTwPK29ROjczHHbQmSbwsQPbDZXtXoI
	 quxDcuXW0gcxnw+xXCfDuMpTWIaiE5i7cDW95j5Wx942q5om7z7DmomdDpaLZS8P6Y
	 DcOzqJqqRz6tsOpIGSj1LwahpatE8lY5MQMCSbDa2e/sqrTEHhP6aNGGj8NAE1+PuY
	 iQ3SiMpMPDUneNk9/Gt6z3CShl2+JPbFLYXboXPr3Quecb1wifO9dAFvUZRl1eAOuS
	 ok86MbTvaGaMCRAPLd6e6QmuysUnFWUDZmQd3AGGNMAKyQhIJ+WO8/gvIyCjJ98NUE
	 0sp/BzQrUgO7Q==
Received: by mail-yx2-f13.google.com with SMTP id 956f58d0204a3-671563fb8beso1780093d50.3
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 04:36:24 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxdjC0f+rhrYpQrD2UxIIHPLwIeXhdLsNwACBkEYvb3Uy9qqEIgbQZRUcGcOLTYN0vdWu6iS+4DRQ==@kvack.org
X-Gm-Message-State: AFuF++nz64mBV+NSgMJaGrU4Kwx1Ii4/lpyAvLf05XPW3vVjynQOxqfR
	bZBoy0yzU2pK0JOrWp7J+Ntf+IZkZYvkK4tiSny9zdpEau3O+VtJNetpZlqLu6jp09ZsRBoV1fy
	sObWMKqXEdTDWCvSVJxzO1DEf9h9xLgCSVTTbIoQ5bA==
X-Received: by 2002:a05:690e:1201:b0:671:2228:1137 with SMTP id
 956f58d0204a3-672ed214fddmr1171793d50.44.1790249783387; Thu, 24 Sep 2026
 04:36:23 -0700 (PDT)
MIME-Version: 1.0
References: <20260920072043.430390-1-hebaoquan@kylinos.cn> <CACePvbXiUmGV920BM58FKuP_iuvhRuoSZrGrrS53rLctJd5uVw@mail.gmail.com>
 <CAN_Opa9usQWbCFL0chY-MCJ94-SQt4neOmcgz2S+_b=90fFZLw@mail.gmail.com>
In-Reply-To: <CAN_Opa9usQWbCFL0chY-MCJ94-SQt4neOmcgz2S+_b=90fFZLw@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 24 Sep 2026 01:36:12 -1000
X-Gmail-Original-Message-ID: <CACePvbXRptS4NttGYhn8eB9RF71tG+W+3sk2Tqp_B8VY2t2kxQ@mail.gmail.com>
X-Gm-Features: AclHuK9PjMulc8iy-yvSPn_DyprVNWJi7bJzfFTbVLPPXA73viopRAtAvMlQgCk
Message-ID: <CACePvbXRptS4NttGYhn8eB9RF71tG+W+3sk2Tqp_B8VY2t2kxQ@mail.gmail.com>
Subject: Re: [RFC PATCH 00/17] mm, swap: xswap writeback to a physical backend
To: KunWu Chan <kunwu.chan@gmail.com>
Cc: Baoquan He <hebaoquan@kylinos.cn>, linux-mm@kvack.org, akpm@linux-foundation.org, 
	kasong@tencent.com, hannes@cmpxchg.org, nphamcs@gmail.com, baohua@kernel.org, 
	youngjun.park@lge.com, david@kernel.org, baoquan.he@linux.dev, 
	gourry@gourry.net, riel@surriel.com, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: wpg7u64fd91tb3g3buxz33odhsdq5tg5
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D5121100007
X-HE-Tag: 1790249784-117676
X-HE-Meta: U2FsdGVkX1+snJKP+aW4XNaFi3alfQazYQthI0BYgAjNa9TycTTPRnOa/oqX34GJKcaiwkAvyGD7TMtPBbWeaWTSC+uExb8tN86EsiDKsxY4IKbSHADnIcI4QT9FX8cVRYB/gkgSRN+I5OqNAewNg8COZSWmsG0hxYnczpUbaTT00DZqXX3RSFnvNKq3mAqvs7iXvwwtaxD4f/ZaSOjJ5VccysYISsxM6gORH6eT/CccxpK9rp+ayAA9uGXIi1w977lfcmowtXax2xQa9EU00XsCqkDcmknaAAN8jiMosXH1pS+CKkbllbIXk+drzCe3X9HeaCWM9DMf0uYwdDa2YF0xABdVJgu3atwQXT8YClutmCPWQ35wxIAB8qJv9qr6PuqxyuvmnPuAJN4F58UbYmFJJF2X+FtVO8jtSA0HEunuqzCeewb8YEObG8t9BpJfgBiGlh8R4SgXZoQ1fLEke1jBDGCwKoEes4ag32tlgzqjVv/+hOjogWEy+e5YSySuiEyIzLQaIq2oELjCJIYVS0w5fjcKmyOhxeJxyk+c0q1K82bd2jwnvXF3AXBaTj95SlFbNf/rpvspsntCXm6fp3rk9wWSd6tLHpfdFnyYyqJZvelnT/cvAgBLy1RGxHxC0BSy1xBwSG/AE05FS1fS0fYOI+kJSY6v1J0DVB0SyyOCIr8J/Mop72pHWNaOIEDGqL62jNYmiQdtb2r4d9tSG0S98kIjxD7tQgbx32kut+5GqIKGrdCkgI9J6NhhVZivG7EeLNKUI1qX/NQwf9ihBWwvBMP30A711M6yWfEgGUa38JEJhJWALUotnem6jRMZIKJ+XGTgoiRBBddveu6YW+hyWegpJCdLydmW6TzK97BUgKGLVd+/z5PyrQKxAM+N+OZl6xe3awLzHXhH6dWjq7DDJDMcBUHgQ7JPercPLaKqGddhldX8V8vY+t1iXJC8Rhi23Pc253hkIC5bqai
 ZHarBF9h
 QcRFulnc7/Vwecn7L/msWZwfnSHpfEf/ozXA9H8T05RYS9vAEKw5dr7i3ftbNENkBwr9f5Ley2Z00LyLy+BK7chV65sqPC2ispzAbuI/kmmKHju0z6NwnttDeRxE2qdN+c3pynFER0X4O7lPNEcKsPgTqMyYGWdWmgHdBP0MGOocU3rW1WkXkQmTC0QQyVFNDspYxtGKiaOcXH7kXP9cYRCBWxQQoqOfjYUWiyijrskn1hU1692EB9kromLKFxbXP7V/Ou9tnQ0DQmqcCyGiXxv5Z8vUGeRLmFrgqIXFNUSDvHzUseaLMhoDxEZtzlnxSKRD6Z0VwjEPJXSf6277d0U2JCDIrY1UyoEmoFzp76z032T4tT4oInU4Lj/BTc44+82Kf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 3:56=E2=80=AFPM KunWu Chan <kunwu.chan@gmail.com> w=
rote:
>
> Hi Chris,
>
> > > - Release: verify the slot still points back to the xswap entry first=
;
> > >   the record can go stale.
> >
> > What do you mean the record can go stale here?
> >
>
> I read the "stale record" here as the xswap-side xs_table[] record
> of the physical slot in patch 04/17. xswap_backend_alloc() sets it
> with xswap_slot_set_backend(), while the physical slot also has a
> reverse mapping installed by xswap_install_rmap().
>
> The two records are maintained separately. In xswap_backend_free(),
> the forward record is cleared only if it still matches, and
> xswap_free_phys_slot() then checks the reverse mapping in the
> physical slot's swap table entry against the xswap entry being freed.
> If the physical slot has already been recycled for another xswap
> entry, that check fails and the slot is left untouched.
>
> So my reading is that xs_table[] can still record a physical slot
> after that slot has been recycled, while the reverse mapping in the
> physical slot's swap table entry identifies a different xswap owner.

I see, thanks for the explanation. So the original sentence can be written =
as:

 "the record can go stale and point to a different xswap entry".

Thanks again

Chris

