Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8E9210ED651
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 10:25:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F4FB6B0096; Fri, 27 Mar 2026 06:25:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CC436B009D; Fri, 27 Mar 2026 06:25:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E1E46B009E; Fri, 27 Mar 2026 06:25:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1CEAC6B0096
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:25:16 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D57C31B9762
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:25:15 +0000 (UTC)
X-FDA: 84591460590.23.6A5B093
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	by imf21.hostedemail.com (Postfix) with ESMTP id BF2F51C0013
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:25:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=G62+lal7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 209.85.210.43 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774607113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s8zHlEOpelJ8OaHxvldDIFJWwtoMMZAhyRutBliNnVo=;
	b=uZh5g2Ja+XzzteP8DCxfxnRcVJs+0+jEVWt/49sOoDTOv+kuXXMW4UrASHYdNAliow6HMW
	tMsh7vza4l3OnTcLjXUJAwC+kGFI7IkRPYplTOLw+5R7dHFXxcyuAyXRFQepnYTQDV4LW5
	ciJHHBKGsBCAuuIb2h5nQhXd1WQ+/zI=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774607113; a=rsa-sha256;
	cv=pass;
	b=ApvX02F3hrcoOjwVtUkCEIRltBdGr2oop7rcdQiX71oiQtrq+7S6jXXLRK5wShY4Bc6X7c
	HpiELWUrq/H+hMOS6eDsCKO8+NVAbPx9QWjXYqv80mu231jXqiRwhQXAXwsoJh90dCHm9j
	VfihPGLN+QJBUgUFs1UJwQnV8GmKwSk=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=G62+lal7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 209.85.210.43 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7d7653db148so1174226a34.2
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:25:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774607113; cv=none;
        d=google.com; s=arc-20240605;
        b=UKdfoMsLVmQZumr/0g+Hv2eeKnAhIurBWNxNiCESqXDhj9Mslt5utG7O4UkHHH2X9c
         7DXFqAABdR1UD8WjdZASX7hrQg0PZYB6Ra3YAHgZZpwO+brwvaK2dmuOcRFQaaN6wI0+
         QZTPlG077bn1347F+u0ucaBsBScTDWqSnzDzrXclbG0SzzyMcEwCErzaQayA+DRFaWdz
         AkZ1VAIIhBAU2AZX69/B6z+QozOeZ49xHkdFfA0YrPGu6ENKriLHl7wjxZKTqdUeg5h8
         h2ZH0MjoJ89AmlriMhZp8pAKOW3uc2fKBscmSMhZq9tCebQxXCER4KCQWEThXG8EsQzs
         7i/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=s8zHlEOpelJ8OaHxvldDIFJWwtoMMZAhyRutBliNnVo=;
        fh=ZTpxH6bz+QM8Y7NgwYOJd9Vm3vYq+cIcPW6hclQ+EYk=;
        b=adG2S+qPAd/bV0zq78s3aIfe46JQVX5ONg6315zfdqNc+EFUvB9Pa5ebO2FfC4Lq/+
         vD5ZicwyDAnddv7t63xX0q+5JRgDrDfnCekDAl6nSI2J41W9aPAOZcIwRorLyGe0slUb
         ONc8LSNpq5uwlv1dZWzr9Q944/M0YAcRkKc/9Osl9KC92X3hfA36DPhQ1KE9QHPth/zB
         e7W3yJThuFd82e7t9HmzBdbUMAcSsxiXjnL0EyE64jpFB3FUkzgsWABqAXN6h9JEFmQ2
         dBjJJPBAa0udx3KWWIgXunG49ZsvE4P2fgWN4xm9+dlPZx7kuub0v5/lUx21/TaeDu9Y
         zxNA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774607113; x=1775211913; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s8zHlEOpelJ8OaHxvldDIFJWwtoMMZAhyRutBliNnVo=;
        b=G62+lal7XT/vPxGNpiv2U0J6IPklU9Om0YZE208ZxL4gY42php0/QfNDA7GSpr+FJI
         9GgnJNFdy+4/L755iZJDNEmDLy85COe8VZVkRX6bN2yubqyDark2kGi8pmKjfUwf9uVA
         rEIqZmnESwrOyHOl6Ee98Dv5DvFPCB11j2ynkVrrYUNsNqmvuV1hUzt1NsK/2h6z2ouG
         xIRRrj+Gj+O0dfQwehsOrLQJtCQIiLdqR8f5yEomJx7f3kE9Cd4LxxUuxUPuD1hme1cH
         /N/058KY+4MSwTtLbZo1IZWsC5L1A8qyf2sRCEYCAa80bLaZhh0kS/DAkl/izvQj7Qd+
         tIwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774607113; x=1775211913;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=s8zHlEOpelJ8OaHxvldDIFJWwtoMMZAhyRutBliNnVo=;
        b=NAPYZUo8C0K4qwAxgEivPC1Nbn2Sgb+OtUv3/AQh5k9PyY2gSn0L5StpOj1V1BrrAi
         wlYR+jXjgQBIrlMOu5Jy96aVyhWQKiZbVeJpWHZN/6viARYoDZfjgz9bj9ioWTZCzKtb
         m0oAiXTOzX/HNbaithv9reZf/LfbfvZgZ44tXXOgjbNLWnX9Lws7LGgtfQmTd4cFS/XR
         k0yk531PSrr7E5VhZBKIXiiqe39w5sbeiYKNOiJUPG+nOo3wT6EwkHGoMYpxJocTi1/D
         lQIFEz7L/R92dzgkWQupmSMr+lMXcvwcvXr7F/3gQ4JYsQHNg94CcUWmABNZoq3aB6aK
         7d9w==
X-Forwarded-Encrypted: i=1; AJvYcCXIfpg2iKX2Su1L0M+aSSPdpES92HEv/cg/MHhw0DrlkIxYhOxzJvbNOyHN+kgULLO0G2krNvSYtg==@kvack.org
X-Gm-Message-State: AOJu0YyMwyrz/msJu5psxH92utx4OX9PKqSxuUH7Ok/Z1BjZ8l5atRFc
	RerSeR24l1Gpv4/E2jMMVpEZsAoPOssRKrZnx3sSC23Ko3nK2MUFC5hGlw/cGccR7U50XAZA/JO
	stI/Dxb32TdwOShZ9QqLvyq0xjxXFiMI=
X-Gm-Gg: ATEYQzzZOOZCfbJJoAbUf9i/DctxC2bSphMkRqNphj1yCg//RjrkL1cnJ630d63KxIo
	Krm7fbM5ksuumJQQsAe3eP3NYw96IVWbnLU/f1L3ZrIPcmCgIMC4EAnTMULMctPoHHzubspGV6m
	GM3ijkf3PG+rTDTyoOEq1q9+h5rPdKFl5yMH7eeuSGV//sMIcjZv2iRfq/ePT5AxWr2TZWFEDRL
	QlqEk54n4N+1citcuzAtrYa2YGPf9NBhXvX7IUDqwZSFOyvhiLLyfNW3YvwagEIGh+7rx1BwYjZ
	EC75C7C0vxAozSkwTA==
X-Received: by 2002:a05:6830:8d1:b0:7d9:f50f:9693 with SMTP id
 46e09a7af769-7d9faf4ca25mr821072a34.23.1774607112582; Fri, 27 Mar 2026
 03:25:12 -0700 (PDT)
MIME-Version: 1.0
References: <20260327055846.248829-1-mikhail.v.gavrilov@gmail.com>
 <acYlxRBhSMcwBnja@hyeyoo> <CABXGCsMTk6kDuJxsTAUKP6npTvp4X6Ryng+P4xjMUsPbTA43+Q@mail.gmail.com>
 <acY5G-lKZQEsUbRw@hyeyoo> <CABXGCsPQo=Npum2aHet3QkZWkWEnEVMAw0KQ1AHPrNjMn=9bmA@mail.gmail.com>
 <acZDJ4Nfw4x7HCSr@hyeyoo>
In-Reply-To: <acZDJ4Nfw4x7HCSr@hyeyoo>
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Date: Fri, 27 Mar 2026 15:25:00 +0500
X-Gm-Features: AQROBzB0-C_A6yb1j1_yQpuE6IZJqUuOjkwiTCpaemv5WY_Vd0aH5YH0GiQl35k
Message-ID: <CABXGCsO_C8++4+oPfZ+bQyrBnEGy5JFpXHkGNpfy+8=5BvVNfg@mail.gmail.com>
Subject: Re: [PATCH] mm/slab: align kmalloc to cacheline when DMA API
 debugging is active
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: vbabka@kernel.org, akpm@linux-foundation.org, hao.li@linux.dev, 
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, 
	stern@rowland.harvard.edu, linux@roeck-us.net, andy.shevchenko@gmail.com, 
	hch@lst.de, Jeff.kirsher@gmail.com, Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: BF2F51C0013
X-Stat-Signature: akwhqswkcznz3hthsah636e5scmj9yt5
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774607113-492825
X-HE-Meta: U2FsdGVkX1++i0myiKxqti2c4dQy6+BStZpAZF+7j7D0S3SrOya3r/oqj91TeOyeM9hZNpTpXC+ZAxDpRUgzFXng4TO0tGeZSOqzBWud6O5GIBEXi03Jrmr/tLOUfImOT0JhFrOcBc4FJw4CvbIbOphbO1t93LiNTPX44aYo+iz5EPTqeIOw+y1K3p+Le7T+zOiKlKvr9N6ul7U/7xrjSVW8v7S2KoNlBGxQVzkdGYkEVYp0rBSytiqbY1JKWs4N/XZUzTKa4GWpag5pYydwuXcifQ0fnyDxBYy+mASGG8/jTn9m3rA/V07dnmoKTIHl2LbU0f2rq4VtKKZurOsrDD9FAS0+CAlMr0VAtdfjtmjx6So9N45Hiz6+h4fDSbw1YxdFYK5I01ZcB/NwnXIb+4ZhHyp3Lfp34tRgcznTcqrp48L889Zope43yLEiQZrwlkr4kd6O0uBMXdNOFxxxPrgXj6OgV4eLhYzIjYc3WatleiToypZZuGTbEEaqVORH5s6hPqbAIUt/AnVKtYrH+SHt3ZARlh31ys6XAqBCkot37zZv5S/5qRGaTTkhXE+Zy5Lha518k2UqSe5r6efvyaFsitF3B/V27rTbAZCOWcIo/vYpi6SIwJWKToK/ZMzTzzN6+IHN43G1WO6iHOp1Q4z3WdyVEhVUqVAVsrDIGfjiiGc70qaTjacA0ZY+91hcTGuEN6tov1coZZytUuxvG8lCoOuxbPZcjWVuynIbFr55ilGvHs3DAI/E6A0KO9ffSSWc7MidiZUJmEbgXfPYhOoHG8SFtSg67jaQW8F59/kco+xx5Krj2pPp1TVEJVpmKr/iNSzgEa1x81/Yz4xOYr/yGR+AltQ4t0CwTvoV5gCPHCTd2jw0hucYkE7Mf7k6TRtLiSabxrmLwojpF/2X8V8hU+w9A1RylwSJNPqeRjjDaOTet9cqZkwRsnd10Lv9EiRYdt3/Z4vU2pSwLy1
 lv7Dgks4
 fOKckzDhPVh0Oj2CBZPA5kvtYJ1WcAVr3JZDoh/w0nNvF0IZvKoOQfokZ0OS6UTrVP/8C6KXs+3lPMSmvpVROFrWk1/fwjz88SKrnMvaexfRY0eP7Y0HI4CclsZVaeoEb3kOeVJ5N6E2wANpq72KuZ2L5Gh7e/9XxKcmkokxnBe9Uub6SHZ1rS15ZYHZVTPEOF1l+Oq9JutmgtFSNtvurd+iQUU6YgPFmVAiQy3teD9xOH2PFeexZcl+sZdy5m14f+HnPUrcDc4duAV5UfiaMlYoNO1O+RJ2NslQ5UFGBBq5Aw0rZXTkLwjPEpEHeX28TGsbLM2jhUB390mpp6S8CwpI7zqIE4USJ9pucGy732GV4aAPgDwVyFgKWss6aEO7zn2coS8fhi3NHO9zSboZuf/a8DKhNPkEqzdAzA4hbcdAOcBwC7RE41ZuLk82Kv850NZi9o76tMfU8rFV2MypactVrxjdgd3zaHwSgOSAIlzGrp0BnsXEpRKO0g8YJUrBgHLhmLjt2opN5gaLIJcqDRU8m6w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 1:43=E2=80=AFPM Harry Yoo (Oracle) <harry@kernel.or=
g> wrote:
>
> Probably what I said was misleading...
>
> I didn't mean "the architecture is fine with overlapping cacheline".
>
> I meant "not defining ARCH_DMA_MINALIGN or defining it as smaller than
> L1_CACHE_BYTES is how architectures tell kmalloc subsystem that
> kmalloc objects don't have to be aligned with cacheline size."
>

Hi Harry,

You're right, I was wrong about dma_get_cache_alignment() -- on
x86_64 without ARCH_HAS_DMA_MINALIGN it returns 1, not
L1_CACHE_BYTES.  Sorry for the confusion.

So your suggestion to suppress the warning in dma-debug when
dma_get_cache_alignment() < L1_CACHE_BYTES would indeed work
on x86_64 and other coherent platforms.

I don't have a strong preference either way.  Both approaches
solve the problem:

  - slab side: prevents the overlap from happening
  - dma-debug side: tolerates the overlap when the arch says
    cacheline alignment isn't required for DMA

Would you prefer I send a v2 with the dma-debug approach instead?
Happy to go whichever direction the maintainers prefer.

--=20
Best Regards,
Mike Gavrilov.

