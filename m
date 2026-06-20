Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13291CD98E4
	for <linux-mm@archiver.kernel.org>; Sat, 20 Jun 2026 16:51:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD52F6B008C; Sat, 20 Jun 2026 12:51:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A86F46B0092; Sat, 20 Jun 2026 12:51:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99BB26B0093; Sat, 20 Jun 2026 12:51:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 740CF6B008C
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 12:51:02 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BF0C8401BE
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 16:51:01 +0000 (UTC)
X-FDA: 84900880722.12.5B2F4ED
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf02.hostedemail.com (Postfix) with ESMTP id D7D0B80007
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 16:50:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HnVOR983;
	spf=pass (imf02.hostedemail.com: domain of yahia.a.abdrabou@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=yahia.a.abdrabou@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781974259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rCvRzKVqqyBHD4TplEtywct58eOLSdQAqV2BMQHPWxE=;
	b=6C1Ux3Q1zVdjZOmhBVeDiScGX3+EZ2DioG1nDGJvbWqk4Rr/HIWORpCRx+Ge4gH0EUsX6y
	p1ANWgj6UYc9TSvk8xTl2t29Gw/rtZVBKmLZ9TtkCKI8UREWXi3056BrlR0NLuDRCYMOWf
	vaw+zZpKM2m+zj94r+rnPlN2wRzITjg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HnVOR983;
	spf=pass (imf02.hostedemail.com: domain of yahia.a.abdrabou@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=yahia.a.abdrabou@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781974259;
	b=r2Em8cLH0GpDeU+CbWFTi4TrxJb3mF3YTkLagYf3sbCAFBptG7zP5VXTBRxmyF4N2MEFST
	GrNbQqLOCPz0CRnAMGqmyKwGs1/q9j6U8fbOa1vRO37dZXCAK76VGy2wwyJMAt4NjssttC
	fGr6bHLQqrAj1mOQd1qjYOkP2QWdfl8=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-45eeea039ebso1711135f8f.1
        for <linux-mm@kvack.org>; Sat, 20 Jun 2026 09:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781974258; x=1782579058; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rCvRzKVqqyBHD4TplEtywct58eOLSdQAqV2BMQHPWxE=;
        b=HnVOR983za4+FN6fTOJadRgPl505zba2K/wgNDl1/7XvNGAckL2Y+voeWwU5dM0qX9
         gVcdgb6FyQ4n2za0uuTZwni1Aq5hyr5RZxkLxij+1Bto7kfGkO+FWaOvUYHS3D8lz8a7
         P6o/X6yMQETxPlRx1RZMNd8orDib5AmX5XQ7xKvW3lWtTMKSlKP0JpDX8ZSFcOwWh6E1
         iWcoBDcwqpIlnQwnBps8guI2gWinC6Hr5P533VKG1BpcYLgXgFxOmOiPa+PS8+Sr5uxf
         /qATc0vci9kxoqWp8dpVau/XfYJszmKRe7oTkxQDvIFtZeu7FZ/Z7FEPxelVl7C2pBVh
         GGBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781974258; x=1782579058;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rCvRzKVqqyBHD4TplEtywct58eOLSdQAqV2BMQHPWxE=;
        b=FMNro0fUGIBquGxEsdVVCelSKQOQ2U7SZAvyZ9+Xo01YALaD0CkOaTU85V07XQHtXu
         BaeQuE0MyV7UIkTHcByhdccMwCmvT7ShwTKnU+2V6zoQKuPbK4NHHYG/nqp4XGnpc0Br
         nYf8NofybgGGIhMuZTri6fR7UVMG6h0pZQe8N8pP84uirmCY+lO4wg57PB0z1Eoc4OGz
         m/ZR4mPDlkRAQeNPu2iGiuAGE6MUeVj3Zqau4FtyylJmkGRW6rZNzI6q7WR4NU4DVLG0
         A/Yvhr8f6+7digloZIxo8hKYANeupq0Zo7x/vb1DoJnt3hZ4aD6pEkw5JUKNgt6e2QIP
         Axqg==
X-Forwarded-Encrypted: i=1; AFNElJ8Doyc4dR1NQwuwKHMP61huxeJ0PQaNzA9fTnR4XePztq91J2Wxcx/tFE8oDyVPMjBmjVVUUkrswA==@kvack.org
X-Gm-Message-State: AOJu0YzqTKkHSVHZtne+rlJgrOOQBidkBCmByJ4wwJIU8uy3ny/ThFGv
	nWdW1HgCGuP/x2ZvPw86N24Te71fE5O/oEA2rIaAbCOC/gUYnSBoBYBm
X-Gm-Gg: AfdE7cl7DN/55CKWTt6+hpa6zUpvxCwglYHcZEZPTNjkeUeWsgnsNaMko3cuEVpJ73l
	Fv9vwHx5ti1qc2eDGLLwrQmY76L7K/iRIIORip7UPCZMPBXaDahYePs8g+zGcYLQcZBwYctzual
	0xk6HchGWWOvDUJ6nWX19uwcXlPLQcjuyBW2sGlN9b9cUl3swQiikWl76Ggt4dmc8A8eJ65szgv
	ic+dFIvpo0oE+dml4LAwOrC9+IwTNfmTD2526Fu+JQuX2OSSUfh9qNdYjgYyvoty83pRekMUHK9
	FHasBg9AgzX+nEjTVop0yQwl5z44R4WaCxQVJ2O6jS69untt7uWau7ZxlAb8xWSAlJ2R4+XswB2
	MWY8Ae8eb5b21zBHTdhQpZSNkL5NfpEh1QHNBdXVXHZEcQoC8EQgM111KfW4eInSPNNjVHdMkEw
	ZXdsbDzMNBFOs=
X-Received: by 2002:a05:6000:386:b0:465:c3a4:a70 with SMTP id ffacd0b85a97d-465c3b35459mr9467451f8f.30.1781974257976;
        Sat, 20 Jun 2026 09:50:57 -0700 (PDT)
Received: from user ([104.28.165.184])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-466643f4d9csm9378273f8f.4.2026.06.20.09.50.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jun 2026 09:50:57 -0700 (PDT)
From: yahia <yahia.a.abdrabou@gmail.com>
To: sj@kernel.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mm/damon/reclaim: fix potential memory leak
Date: Sat, 20 Jun 2026 19:50:55 +0300
Message-ID: <20260620165055.7247-1-yahia.a.abdrabou@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260620164004.86461-1-sj@kernel.org>
References: <20260620164004.86461-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D7D0B80007
X-Stat-Signature: 681xik13mx39jqs5znk4irc1ie1jtekd
X-HE-Tag: 1781974259-643563
X-HE-Meta: U2FsdGVkX196A5dvxrU4NQAG4NzlmGAYuS8Gkz90YRTUO+nXNGYZ1w+oa/SuuQG/PM4r1kc8NGSqzlNW5W6owYNe1MEul0Gl6ycMrv9xYx46q+Im4ZoBsrJcNjAdEQ2QpYbwHsVvPdsWWqaXDFDLmCv3uuRuyADEyTEtGKKjEd9Zx+Xu8vQUpgebea5GXzCvsmrheJJshpAMUvm9+HZzAoRWCx1xOarKC+AAGnmfCihMngxmZnJLG6ClUxCYnBpuNGnVuyNVv2d6nKNEW9ja6HVBseYn3jZ9dlDRXb1y4F7yRkMTpAE1B9vs1kLS/69C0EXPCC7Pa0Zz+TpqIP/fU5SQMOha1Ml3zQpxLIJCMm0tC08N/e0xTtVTgtxDgT2lTH7kmOqCFJXN0ogB+zukOP84/yKXXL8v/b+0kFAsZmaJfbsoGk6tXEdX6wbmJC8P1GLSz2MkmHVe8xKBLiUq6bfGg0uRn8PgzeVEvOBKUm14riZIevFprivexsA+vFQ4V2+PWwC+rhHfmVNSodz8Q8lQm/4NC2zhvVKJVGEp7TDGPXajgMJIYprx7PbFhUu9R0zx37FKATtAallh1DKoiQsmZWCUZ3bp5jcY8z6JDzPF6bSFXCzB91DTHO2lRZJwV5uk4Q89hXlj14UgeWsiiQGKq3rZGTwi4A3riTDLeZOR3Jzuleosw267M72hWmZlIqNs8GrLUdvdzxkUks72QlIQ8yIpI4k4sVdqJLD/7Yv13ofqjrsKHY4OfZa8i5SDa4YCvJccuXQNzvtuPH1QReNYLDO3ab4Uy8RfTFJ4FnJEQdavxBwHq4ME2ssNbkU6g89SOicXAE4381qiOywrUJH9iLKDC4Oz5oyxQBNTxEQLZdKg3SffaLwje4j3xmSESCBvT/aYPQIgI7UqvWxxZ6XYQ9tI763hSAFBBoe0MiEvDamIHOOD46DFEg4lmyCpR4Ty5+XYBkE0L7gauf9
 adzFP4fH
 qgP1JKdeL4fgKBWTL7sKOL5DErTCnlN/veNnn62whdDcVw+L34EBWUqZ+hGleTa4yOebWAzSGrcEa+UrzKZDQBCLDelFA5HTZe2YR913AXB/IQqOBagzwtIdnqHtMWxzaO9jUBr15tL+EW7UQgCI/mP0J3HD++86QWYoBZ/ncs/v2mM7UA9SJl78ivwO93Fq74q1DvwN6wod2xpWpucASMCOasbUQL9QPnts+gaK5uERXVLc9Jz+zyeS/wR+PEVArbNIbLiHhdwfuYJ0NmetOyTFE4LjJ9XOvsqcTtjNtcZOjpnswfRFPpsg7oc1o/hVY6GH1QSFMLUWHRWeQsytIz7w4qhm4nbvT73RfVKhePSls4wRu6DEfp2URmFLGIrlfiI8shmdEpH6v0jEzRsYkezMduUqyQpDexLViNhMGpzLWQuW8jqecI+aZ9/1qh+y9JrTm+NyxJcKFqvU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

Regarding you question in v1, This patch
addresses a potential memory leak in the
out path, ctx is never destroyed during exit
thus creating a potential memory leak.

Best regards,
Yahia

