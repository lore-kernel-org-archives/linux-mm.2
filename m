Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1282F428DA
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 20:20:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AC5A6B0005; Wed, 15 Apr 2026 16:20:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75D316B0089; Wed, 15 Apr 2026 16:20:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FDF46B008A; Wed, 15 Apr 2026 16:20:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 51CC96B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 16:20:46 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1042DC220F
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 20:20:46 +0000 (UTC)
X-FDA: 84661908492.23.D0F5117
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0E65B12000B
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 20:20:43 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=SNQDWVv8;
	spf=pass (imf29.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.48 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776284444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RD0WZ4vxceOe2Q9LtAJJvUrGVmgktyPaNbz/Rw5H6EM=;
	b=hX4UXeEeG3hEFRyAcMKg8R4WdKFhCbKddA2IRbROrbxxjnbmtA4NrJhTNhOs6R9960b45U
	ieP2FYkuP9oGZnhB3zH/ug1BdeaQYsozyTwLTwdlG0yC+JqLby5eSPxv8j4idEw8CL1loQ
	rZLbruT2l+kqPvxXtRq5F6pnOfXlwNE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=SNQDWVv8;
	spf=pass (imf29.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.48 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776284444; a=rsa-sha256;
	cv=none;
	b=HTPF/NjJ5fkqSd6sbX8nW4VwBZgRsDqMQr+Ro6eoD77Gqx+HrOLouGE91hjstn/b+sjr0e
	XcagVIKIjPSW71y5vHTaZXmGmH2m0GDynU3eDljZe5bNlhWoE1/TrFnteK2ydzk5ZQ3OtZ
	6tDv7x9YqLDicgy3g2ivHQ9B47acq90=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-671ae79e617so4569430a12.3
        for <linux-mm@kvack.org>; Wed, 15 Apr 2026 13:20:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1776284442; x=1776889242; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RD0WZ4vxceOe2Q9LtAJJvUrGVmgktyPaNbz/Rw5H6EM=;
        b=SNQDWVv8iZ/cKibEPRC3ud0BprjlpsHN280CFDLtp6/Gxm0aNNFHsimjRsjVaL94v4
         XJUHCp6UGtzJ9VFZBszBqf1i6vLU3K24qmRMa2TMunXu6a1bNn3JbRHkQmShq5zlbF60
         rNWvJEY5sTs/EUQBZVbS8DyO1qTa9qoS32Tfg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776284442; x=1776889242;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RD0WZ4vxceOe2Q9LtAJJvUrGVmgktyPaNbz/Rw5H6EM=;
        b=UXd7YZi8Q4kq5HYVNRrsB8SGEIlLEHQtKrwMmZWWG/go9TlOU8XdGWn9iS/GUyl57t
         4XHdbVz6wEi6p1feTpVeFtjSuiBWpW1I+j0vqZyZDejk7Aa1/xbRNI4+csU1vX/x6JMQ
         ntXS0u8iDtm8fChiWYo4YqrWzKlyPBbR7DnaJHlRr1Xe+9v6bVMzyRgZkVAsgss1EIEB
         qKNEecJYVzENFVYEDXAjR8et0uLBcO/c3ryui3Av6ix4/282bNwY1J0fy/BU4G58snYv
         6GdB91GrGl93r7aKJSEt7lmnSi2vT6fLK61ZVPVkv2cEX+qn91vG4veY1QzUStcMym1K
         WMxg==
X-Gm-Message-State: AOJu0YyOYiWE+C26pDxD20o/4VEvEHF4hEXgX2q9lRgV7+xjpOWWRbug
	52ZXipHE7SDiU6gkDW9u3QlaOeIqDr6vErT7yVtTh3avBl+FKLZh4XOJGlvCLRZgYJ+m2TOWmBX
	iVx5XoztyQQ==
X-Gm-Gg: AeBDieu7ekXx6BlXlOd5/F6mdGQu3GAkqCpX5uKoxdB47Sz9xPKslS9gGmInctj+yRE
	xYdiSiooOvNJbalDQYcokq5HgNdya2Q5KMNbIiqD6W8m//ES+cNErKE5Bq6u3O/dPBXKGKwa20h
	STa2QvSH3APQ/Cl2PwP118EI4HeL2vQr1ARBQ5Bvopu249HPPuPNOCQ3ZIyv/ByqLiOR+of+xe4
	Mli67BkK37xmi5DR756g3xe2kDuKNwKugQ8aI77UBekxmfa1aPFdLxAINO9+Z6LxeXHfsIv56g3
	gEGKoZ74/wK/PGbAbFhKGAev52W8YpKFGoyWQms+jj4qAaExsVPBy51m4dy7Ku8nDVqJ3HvEqMa
	fm3bMpMGo3W6uhQyzqPC/nWGbiaOXaT+kkcd5ttcVuDlSDmXyCA98aS6G8/OLSi01iaJ8utnNQl
	qeUvVRaYf3pUPFk+DJJ0O7dMK13nTMfj8GQvA/P8Uy1i+ZR/9EjREQIivaF1sm4IuWCt7I9Gcn
X-Received: by 2002:a17:906:6a26:b0:b97:464:956e with SMTP id a640c23a62f3a-b9d7297daedmr1354410766b.34.1776284442005;
        Wed, 15 Apr 2026 13:20:42 -0700 (PDT)
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com. [209.85.208.50])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ba1773c5318sm93609066b.41.2026.04.15.13.20.41
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Apr 2026 13:20:41 -0700 (PDT)
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-66f8f556f39so9744264a12.0
        for <linux-mm@kvack.org>; Wed, 15 Apr 2026 13:20:41 -0700 (PDT)
X-Received: by 2002:a05:6402:3596:b0:672:7298:31a2 with SMTP id
 4fb4d7f45d1cf-672729837ebmr124115a12.7.1776284440889; Wed, 15 Apr 2026
 13:20:40 -0700 (PDT)
MIME-Version: 1.0
References: <20260413214952.62836ac9df0eb348ee4aeb2b@linux-foundation.org>
In-Reply-To: <20260413214952.62836ac9df0eb348ee4aeb2b@linux-foundation.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 15 Apr 2026 13:20:23 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjMroU7PofBOC52f5u5bTjTO2tm5ehycf9evmjeq-hq3Q@mail.gmail.com>
X-Gm-Features: AQROBzCKylPsnYLo4V0oRH2sXSLCdE6OFA3N89cLViHqNyOTdUIjQqN5FrzJ8QI
Message-ID: <CAHk-=wjMroU7PofBOC52f5u5bTjTO2tm5ehycf9evmjeq-hq3Q@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 7.1-rc1
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: y7nguqkds1hxu46pseqxm7fryrz86zje
X-Rspamd-Queue-Id: 0E65B12000B
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776284443-318994
X-HE-Meta: U2FsdGVkX191+bLlJvxsH9c5fcShWdHrI3mEFBrerDGHgMoMFeHHasyqn21w16VUNpl96zoa2XJattqPsI75xKYQf1ttMxN4NUud7lw+nMejIQvQbJmko58akXNscVonqL3Z+J6G2DbYK3jY0O0woT5xFLIu9m2BWYRr9mgIrw00TRiJj8acmOpLbkUifmJPUuq6H40PxkEMRaKrSALGwTNVsuViNY/UxeYdzx3+fUxnrgKSuIbWjj0mE48BGkQiNVFUa821bbvnyCWMjrMWG4YWUquZS4s7xepDOcMpkR1a2rNp+/7hT+dBGdu8Iqwc8/QT4V4cYApcnMPCd1xXQmsIKCIOgDCZkHtX+BC4xRyk/vpp1Ehb8bUUW72B1EUYaIUL8AY0kk5fo/TqGd7cz+L9FKeTev3dQ1hWtBG7f7UKtmzDwWljY3UDDVmkiGGvE+j6EBOWR+N/1qRzXVUinrPCQg6ArINHmzE1WvOi9WvpM/QqCzKthuyB4scQICDRsD7pO+qRufN6sxfpnAck1P230sLjwj37W23rsybfVwSmCkEVMwkyQDtsnpHOiU2KA3dw6KndojtgrGnWYk1uZyU+iRfDzzTrVLXlzhxV+VxJwfipRkp9rsJtAI4xhn3yovIKLe4U2BBo7Cp1vWKjLQA4lCMxP4DSxkS0TJR1nFZd4Rw47AzZCmoVC3PCt3BA84URYSHk7M8lXT5UbxbsM6z1ykVKFoNkta0wINZfVyuBWEm/8sKetJSM9++mRgKkgXfJRi22SnlQtEP3ew7t3vGuV4prhP7XeYN1b+aU+OfyWcp0E9DQZ9U65b9WhC4BuReAmDXe6jIyhJTIOmSihTF8Tsixl2C+AgnaLO5oOUPAAj9iSUGZwgpZlmvQHhdfjljDTHRvrP0n3eYrmZFBT7woCkmyPzjac6FBz+EFbVGVl7xG5ZHVW/wAE2ee97AbKay9uyQL480lfaR/tA9
 19J44kJE
 tAozxKTfMDiUgqiph17gYnY0XwQPlww+pg4aX5hB/9WGvMGuTvZpdN0I+9hjaz6w/VKotM6YOn9GesX2V2+n8Q+cxLquiIVg6yReX2CKllgSDKOpXS3+2fHfGuUc7QfaLvTATYt9bedrTsAZ/SQ/KvoLWdqg0dIprc0LBREM0SpvbNaFUoiBzxfbKxPhelqqJT2ywtZLKUIm8nvaz75SWyxofUyBaibinbMM0chLoJsHHXUTaYYl0CZ2abBgeof4ZVApM9YsAYrO4p0eMsRUDj7gYWLowbnK0t0zEZZS7WgSBYmf1THbLoz2EyBKWTRe/2X5gHtEQoA2htjl7JbOv30UDSCOgHODVg+eVoJd1Osmlxx16GQJKrUsyKc6CVgI9Yjt4P4j8sSNNDQljqBKgEug/anbfBjL4b1gFxiqWICW2xZuZLgFv6PJ2/iAmzqpV+ZyGHxmhtGQ0q5niFkkdskb7PEb7xqlBC4YBN45dGu/Owxfs38iiomekxuLU/6OuG3RiCwE/SigJWJyeU0lqSCCVD9w22L58APV6blj3OcajBTemsVwPNYjLy5+Ag0zIl6d8BnmFx945ompeQWFaxhA2RY0JJn49v2CojsG8lcmqxAU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 13 Apr 2026 at 21:50, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> include/net/netmem.h, vs net tree:
>         https://lkml.kernel.org/r/aaGiDINfnUexT9Px@sirena.org.uk

None of your links work for me, all resulting in "403 Forbidden"

The proper format would seem to be

    https://lore.kernel.org/all/aaGiDINfnUexT9Px@sirena.org.uk/

(or "lkml" instead of "all" if you want to be more specific).

Maybe something changed recently, or maybe your scripting for this is
just broken?

               Linus

