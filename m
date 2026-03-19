Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9ED21075260
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 06:47:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8EC16B0401; Thu, 19 Mar 2026 02:47:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3F7F6B0402; Thu, 19 Mar 2026 02:47:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92EE26B0403; Thu, 19 Mar 2026 02:47:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8277B6B0401
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 02:47:23 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 15D3A1B7D80
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 06:47:23 +0000 (UTC)
X-FDA: 84561881166.01.D12AF9E
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0D0BAA0005
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 06:47:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FRH3JgrF;
	spf=pass (imf15.hostedemail.com: domain of richardycc@google.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=richardycc@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773902841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lAttBectZTjw795r1OEozVo4lU/N2EpOMcEeA6wKQPA=;
	b=lUo5RKAiDDzu6frDRv8irhljDZevpHyfqjHXaTi02DGmmuvP8ZDJ7LyAd5zAfs/kmbQZUy
	2cqakMcRdmFGhT2X9DBIj4Cf2PwbJy6SoEgG/7fX9ypS8NcN8bn1I7/RkpGyZxz46BX1MP
	d7vUlNK5IqLP3NiJ2fLcQltnO4VuMAQ=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FRH3JgrF;
	spf=pass (imf15.hostedemail.com: domain of richardycc@google.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=richardycc@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773902841; a=rsa-sha256;
	cv=pass;
	b=XVEiWKHlyxklo9/ZOv2foeF8xZi8H2N1LJdGqXpas8qs1Q0ho9VlZjIgcZ/HafkkmLffNJ
	JFfiaQYsrSM+BROpOlV5rRGN/6nYOE6GHraXX8Uv7n4NjBVrbPmn4eISLoct6nW4T1nCVn
	GfwbbOVebsENF2b2uY75otPBTLUAfQk=
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5a10a116145so2917e87.1
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 23:47:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773902839; cv=none;
        d=google.com; s=arc-20240605;
        b=cGMoINtsH1BCXzXMKC6uYQArSA/RT5tkKHQY+2oNpG7Uk1LBbAzcYWFfI6cw0CAR26
         tOZ2y2bELmvMwusHkc3fcGEn4ixw5gBZT0q1EARxrCiAm2xe2+hhZcHvpA+IvnvpcPuZ
         lQzw8tajO0bAfYu3T3wAPY21C7WYtBerY5h22VTVOFunfy9Tha7fxI6xwCndN+2FZ35O
         zbp/xQeBSbBwb0DN5vPoRJKlzzPg2OvKALTaMiE4aFAHUqg3zL7yE/E2pZEU1H8XQqQp
         HrSphr19yl8YPQMkw8FIKChmYtc5sg9ESQWlvlkQeNZgSg7Wh0htuw+pBDedhAkU3qCX
         QHMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lAttBectZTjw795r1OEozVo4lU/N2EpOMcEeA6wKQPA=;
        fh=oAEOHsBH8iBeO9INy8keUoFRUsYlG0dkbTBy22BRf0w=;
        b=BNzIWRySCo26NdShaChtCG8PYmkoVvSToKwSXJdA56rox7G0UbBK6adoTOaFoKWJIf
         FFHmdq0tqxrONQ7p9FlDoxUImP5FR5xW9R516SwEsOjhLvO3zAkITDaFQ7VdZldCosA+
         flvElNiE0Tympd4FKJZIf3oi8iRXZLBsQUGf7VXQdC6oBtHKOSfLTiUxHAXa0XHSdbAT
         JukIAV7i4uaOvmeMli4MGXocgLsQsnVuNtF72qH+2B5+RC3BTc6p43mBjwOZSv21FIM2
         /HYfSxTJA6KIRsunN6Q5heNZIgmU+zrYQvmfyscEhA72Wz9gI/8bGFg2/lFJrkQT3AL1
         Bcnw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773902839; x=1774507639; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lAttBectZTjw795r1OEozVo4lU/N2EpOMcEeA6wKQPA=;
        b=FRH3JgrFrhlvgFz60EyEnJ1LaTW2Ork1Q4oWcQscRe1J+NLvZqgB48x/Rs14OToKM9
         4FvtI/yA2exkSvIJlbi4XlCl+4HVKHD1sJjwrqfl679Pwo8Sc37GHOdMXaSa4jq0+Ikd
         JIveeiPp7EmrPGrO5rk/W7lSm6J4+ux4Ap8/bgCeQHbuPtSsqMxqZAfPE75fD3adu1Tc
         daVmQKCE6eTmvV4GN9xXVjgWyMiFv/Vo+RDLSvqF+rsWCwvPKTGMLvrMtroOM0C45oMP
         K97vckF9ika51DygZwE/RRJLD2bshcCc8WYhB1Pwzz8zNQ7nBVIcGNQ+XXcGklqRbcXn
         aHkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773902839; x=1774507639;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lAttBectZTjw795r1OEozVo4lU/N2EpOMcEeA6wKQPA=;
        b=Yw2Ek8Rw91DOjkp6WRUrNGg/LA3DQTH/67S2hMpD4fTNZmO8HDvvE8ZzUtM7sQou5f
         krbEOX9qfjp1G+9jrJ/hBVm8JcUYkC8ZfZ/lN+kzxrni2lYUUZoPLDZZCRb9Rp8NGWG5
         WAlTSk1ACWzl/jWGwSUGYE1mQ2UIBv2JKYm1HsgKltIUaXq66c2kmxOE8x4pjLJtnCbI
         Vu1dqgosQgU88VaH9Qrj02lpQQTo7a7udwlhWXqECaiakaPPuGNC0FFCXOMvQ6n8asow
         MpXdSJvIKrOCR8KtvM7wVDWyb0sFz0KteH7I/e0tYZKGKF3KwJYPAdHr5b3e/5m7SF8P
         UElA==
X-Forwarded-Encrypted: i=1; AJvYcCWE9yPqftYWiSiCqwAqRsO7XGkmsIqRFJLXPnELck9m8h0Tq4VXXFz+WAc1REIq2xdIAnV6ICXurA==@kvack.org
X-Gm-Message-State: AOJu0YwPVwnxZjvrZIuoMxv7Ub7gQTECI2F02VPgweyVkj8UZ3Ot0nzl
	Mj+yk+hmGkZIF7MP1VGXE+V/3YDWKs4XmnoSSBXHrCc4ADzM1gILte6DNzk/1Cd97DyWo42I34f
	ojgBK6Pfea2uDO3YNHfN+2xFABdii4pQH7wo4LxE=
X-Gm-Gg: ATEYQzwkGWCoSoBB1frWtExjah/LI3x/HluXviX9eey0JCQ/KIPX+9WCCSTXPRBit/F
	ymDkw2aO8t36IES6+FWJQMH2l5QlPB2r/Jr/6fjLHpgqlXt/wFmjHN3fVqQ2m0c1Y01kjh0acD5
	rQFNBS1n9ZNbgF/KsEpzrloBjBUasY39RMgDq53LuIghWpD8ueYFozEemwdK2pntuKLEJpAaeh6
	vor2Xo4ke6F0g2eMUtD9Fmvol0dQw/SLsP3FI2H6YrlxfwzWLz+mUuXf+GB8QWVyU9hvvv2FG5o
	Qr384he0nfKo11AAngmRVMnuz5X9CfQy+8hm
X-Received: by 2002:a05:6512:20f:b0:5a2:78cd:9dc8 with SMTP id
 2adb3069b0e04-5a27e5e721dmr89654e87.10.1773902838640; Wed, 18 Mar 2026
 23:47:18 -0700 (PDT)
MIME-Version: 1.0
References: <20260319034912.1894770-1-senozhatsky@chromium.org> <abt1dsjsT9826Ewy@google.com>
In-Reply-To: <abt1dsjsT9826Ewy@google.com>
From: Richard Chang <richardycc@google.com>
Date: Thu, 19 Mar 2026 14:47:07 +0800
X-Gm-Features: AaiRm52xZVJx1NkWEeoXPAJia0WXKTWJiqb9srzkPoIL8aJm3hm6Kd3ZjNlT7F0
Message-ID: <CALC_0q_2meJ7T8gvij5oR=idy9hn5rMC_RQhCbePJFVBOOd0Tw@mail.gmail.com>
Subject: Re: [PATCH] zram: do not slot_free() written-back slots
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Minchan Kim <minchan@kernel.org>, 
	Brian Geffon <bgeffon@google.com>, linux-block@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0D0BAA0005
X-Stat-Signature: nb3w9yjb57d5i51zw3p64rgt5aw34c86
X-Rspam-User: 
X-HE-Tag: 1773902840-76087
X-HE-Meta: U2FsdGVkX181RMnE4i3qYFm1w29CghvbwBez60AXar5IPsOfy5W4b/sx/oeIJcCaPktAKq9XRRsnmWuJQs50rJE/N54yQrLXp5h5fasfGSqh6W+Pr3MWb7i678CuFV11xxD6pKZ6oRvc/cQ+8frZvMbfUsdrjLMn6xx9w32tly9jU3UUrOTuKwfeZqcZbectwdQqnPvV5h4i40RqkV79MNhdtiHAhBNvlKjF2x89/AGJfiJuRlMngkhz8xg0WEdj4kOCk8dONlcn3dS17sRSUGBDSagAN6Mgr/YTV0kyf2yPWh2+fHCVzLLKxSMxVA3T08Up6/dNCdvkBtzDUWdb7BFB5z49zwLZjGBD/U4noBD9E6nZPT+yjZzmeqU+xgVqIITKmR0/mE2H6DWcIcslb8CaxEh5tHgmHZ8eCVq1vA1XvhGYaRR74f/LD7zt5aY2mPy+GI2j69QR38cvp02ZCZJ+01sGi0Rq1ePuRd2E6RZlK6jEg+hlk7HkZhMOW4QWhDIG4b+xaqP6zRwgtzm/KmiINlaVA3DpyhpzkvuA/2WWSdUxxunWinAAN/QDa8PrzP2LbuScknRLq74gBgbSJGIXcaq6zKGnkoH8qa+PhpmJEnnKO1RhX/egvpcpmLWwlqMr5BDVQABad/fPmW5891tNWe7nI8ulCvZ4c5fCEPgThLvyca8LRZDNSOwKOrENDB0PeDPDW9fGqpjnB8T/HR2H//8UnZahCo0+shjxcuS9/xa26POCALo5Kfwn+uU1aX8J+J/TOeYjdW5ifjTPHxky2VwTNRoNQZXR4iDhtRNckGPMFPNYJgN4mSuR1T3fsJVvmJuW4JA3FtQk+4mhcxDC/4cahpiUYK7Afqn3zEtlH490HvDUmMt17JvsEnVNgyNJYxTQPCLPm2rQcxj+MXF5cjiaet8BodE8paWfvXI2/McgdmzaobIm7HRc6mjr3Vmc9i7h0tK9iPQ/Gi/
 6lIXaj10
 xSeofsxxGgKpzIecxxmqEJ6JOxHmGWr92l6EJ/09dwjVjziWLe8Lv1ncQ5+PV/SxdCpzeoT7R6K8dIjqmqtdkIaHvWazzE9pX61/CCoSXcOXvaZQOvFE/h5PLH1RadFrPHTgHcp8UM4bFn5kkToaMkl1wEzc6m/Cp+6V1x9Iwc9a/AjqXT5qI5E4W4/FvLJFCQvZfmJ5+6uhA5UaL8Fj6XbzWGVC9ELOJWa04kmCPoZ/+lKgayzgBUHYDD1O2dSnSak4h0n7xE3CLUMhLVvYmhFZsgE/cyxLBMuY6roYOI/x68jdopHzwZGj9aw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I think we also need clear_slot_flag(zram, index, ZRAM_PP_SLOT)

On Thu, Mar 19, 2026 at 12:06=E2=80=AFPM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
> As a side note:
>
> On (26/03/19 12:44), Sergey Senozhatsky wrote:
> > -     slot_free(zram, index);
> [..]
> > -             if (huge)
> > -                     set_slot_flag(zram, index, ZRAM_HUGE);
>
> Original code had a bug.  slot_free() would decrement ->huge_pages,
> then writeback completion would restore the HUGE flag, so when slot
> would get freed for real slot_free() would decrement ->huge_pages
> again, leading to underflow.

