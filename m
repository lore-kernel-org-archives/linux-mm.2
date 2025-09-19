Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2103CAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 15:07:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED95F94000A; Fri, 19 Sep 2025 11:07:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB1018E0019; Fri, 19 Sep 2025 11:07:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEDD194000A; Fri, 19 Sep 2025 11:07:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CD7958E0019
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 11:07:55 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9DD0A58929
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 15:07:55 +0000 (UTC)
X-FDA: 83906329710.13.2E0E2FA
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf15.hostedemail.com (Postfix) with ESMTP id A6B6CA0006
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 15:07:53 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Xwcgfb/d";
	spf=pass (imf15.hostedemail.com: domain of glider@google.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758294473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ls0ueed/BxHP3QtDBUTzflUrtNvfsIQ0artI+JKf/HI=;
	b=h/JfrtyiV8LHeR1eN4aJQNJcWr+Lqw7P288lWoa/vBbdjfzkfEF92TvcxhWda6OHugszVO
	JeJy5DKakdbP8ne4fQbZyE2IR91Asyg9CfQ2NVZ7mCyMe4iiE+ytQn83zA8MQCQfS70DeY
	N9muVqw221GzrKQsOWft6jkzVWSai+g=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Xwcgfb/d";
	spf=pass (imf15.hostedemail.com: domain of glider@google.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758294473; a=rsa-sha256;
	cv=none;
	b=L92Y/vkivzSVcOcDQ+w8l5KWg7FYS++ouuxOpSfKDDa3+IfEeK/zey5e1pM1BRaCo6aQis
	DfxkfPohVPjpf2eGcCgH5gTsq7R9dAA+E3lXjOUqrTh9yEvjZ/oseJveL8JEK7i93YijSh
	FKrHWc1S74L0SaQSEN4vyb9IqiWtlxQ=
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-7900952fb89so19251106d6.3
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 08:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758294473; x=1758899273; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ls0ueed/BxHP3QtDBUTzflUrtNvfsIQ0artI+JKf/HI=;
        b=Xwcgfb/dho1WM5eSfVzLyysp4p0syXEdtbqM0GCeKEz0O1j1NRVwXCMx7/DqMaimAb
         ZiLySzlRnV5S/bhFZfuPgrRTRuI+KOd8jPpGwWy1CBU8b4GT6736/a8XPXA9prCR580s
         9UkYmGQQIDg0io45mU4LuZaOi+vwrgYRoe1gkptWMUYyq0JCsFJWgLlaaca8/OLs4Hlx
         LJiV9RsCKBHM5JR5wFFiB3uI+bysWbFZVhekKDudU3P+oJrPem9nTbhQD42AQbaJQy5V
         lzx6drzlQQtrDUWoRSuNRUJmLsxEkJSSVdZ851uK6Ysp9iokBIArR9J4SOyMuSQYmM3U
         8n4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758294473; x=1758899273;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ls0ueed/BxHP3QtDBUTzflUrtNvfsIQ0artI+JKf/HI=;
        b=DuKHQ/ALzoa3+2NDVMyyQGAxkyOcub1Gp380yny05MCieJ6G+aF+icMwCAH1ggxWJ2
         pfBgse5FEImYT/p7nU6J4fa4RzBuJy77V9T6qQAEFc1DFEX/FPU2Zd8gl4hYVuIgDRaf
         0Zw31LJDfy4vGHB8VT4IoxNrgy0eY+HguM1lkyjtXo9MPaYgaqQXREDgiW88HQJl+KsO
         uVjz4BOdLagQ7ugz6lwX/7spCqtl3JVLreeKl2imQCED8lxvMRH7er+cMHaN5tLM/hI7
         YieTkUE4K4xZp5M1P1ctpqrdj9imM3Cy8FuT2PMHsqzrsL6bqSfuQMrjAPt2BMegQ4mz
         VS9w==
X-Forwarded-Encrypted: i=1; AJvYcCWgwNQoZ05/Y4usGU27iqhpOV/xIDlH20J7Zeu9/8J+Put9ClF2J42zr2MLNVXtWnzt9betK+48FA==@kvack.org
X-Gm-Message-State: AOJu0Yzvu48rYvbIQVL2UP26V8jOEPUT8se0rsug9xNNhMQdSML4+LGc
	5J9ihlqaT1FZstdsy8fsOx/n9qHjh68Pis74can/AILtMXXL+TnshcKZ0BpMnB+Wr302KU1BJHz
	9oIfaYq1SIySJH/ckq80a5sJQ57NFZKpjLT0qnJ0k
X-Gm-Gg: ASbGncumqRHP4KuwY9oZKoXGyLwUd2XUU+DKswLBFx36yx36daf+Jx1osHpyYPPhqZy
	rGv5QFUMi0BHYiNx/SEk0HcbUdPa8z0DiBGsVNHKmGi+Np49vTIaHfTrQp/YT0nVtq3tamXXqj3
	YgIiTMMQkOZsR0dxdTQz9oqHX1bWywYgy0JDR5TMOQxCuA44QN14esTxfm/JAxkxIQU/tV3oNtZ
	tO7xQJLNDN8zLXz+z0BVI9KPlf1FbhY76t1fw==
X-Google-Smtp-Source: AGHT+IFrJzJuFA3uDy0oX1I+l6xaOubdUHrA6zUrrdRHERulJyx2tdaDsHhWPYomdV64GyBaRo1A+0ilKwtQxafKibQ=
X-Received: by 2002:a05:6214:260a:b0:780:24d7:fd35 with SMTP id
 6a1803df08f44-7991b0db9bfmr38784486d6.43.1758294471475; Fri, 19 Sep 2025
 08:07:51 -0700 (PDT)
MIME-Version: 1.0
References: <20250919145750.3448393-1-ethan.w.s.graham@gmail.com> <20250919145750.3448393-9-ethan.w.s.graham@gmail.com>
In-Reply-To: <20250919145750.3448393-9-ethan.w.s.graham@gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Fri, 19 Sep 2025 17:07:14 +0200
X-Gm-Features: AS18NWCM6kR1_nk7adaxFawciRK7byb-Gyk4MeMsfOVVpcb45qo2C2pvMXupxjs
Message-ID: <CAG_fn=Xvkz_-UGuR8_4Jb_9HmwQn7dTHdJuDRe6usZX61CF0xw@mail.gmail.com>
Subject: Re: [PATCH v2 08/10] drivers/auxdisplay: add a KFuzzTest for parse_xy()
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: ethangraham@google.com, andreyknvl@gmail.com, andy@kernel.org, 
	brauner@kernel.org, brendan.higgins@linux.dev, davem@davemloft.net, 
	davidgow@google.com, dhowells@redhat.com, dvyukov@google.com, 
	elver@google.com, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lukas@wunner.de, rmoar@google.com, shuah@kernel.org, 
	sj@kernel.org, tarasmadan@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A6B6CA0006
X-Stat-Signature: fkyje5ctfiaiyckcfo11t1geuk4o7wne
X-HE-Tag: 1758294473-382213
X-HE-Meta: U2FsdGVkX1/WkQNazLNm0ixXm5j7Anq81226sqH8q3VSNCDURNKFPjH2VGoeq+d6pQ8thbRPgKEhzM5rPfDNZliCBnJzTN9uRYFPVrBSEna5kWhk1ywt4lHTwY2R78pSH9bZfpdZgtIc26+tO+L5Xm0Zdhr1066zDEN81YYpEJcbJES229ro7c4nxa9tgHCVuMHOvlPby7kmsqKvIbqr4+KTwrOswT+1bagkkRkt09bPRP5nSvl4BJWghrscwvLvMzUiI+wLMXgCPgzOuQl8ExqcbeidZo+zkeov5sndkUz80G3dBKpGyV+OhBra0WGR2sVCB3RhOcqZzxqhOiSSIxDVfbFORPaf44YmwdfMII1uFxP7KUw1Gqfb1kB9FQ3R8Sg6J227KkvMu0RZFy9ALXik2sHGCwhfQ5Cy8N7+bE2fEaqbL4IFcciF2yTF4PmqBZn67ZTEke8brwIToc/wk4XbwCjUkkPpFIKnD2pNceo5a1b7S/WMK8dP/iPU/CqQRfsTvVOJFAJlNjTwpdONcvD0pxLrwm7UgaKbyvyZWzwj6PeIOoq6Ot09M+qOTFcPPIcrcoYfV5+2HXaim8ELWgyhIx0mLrnR1rq69L/z6DukRwyrDibnXRiFBx2DFqbD5NGO7x1LZmaxW0zIxfW+peI9Dayz5n546NSXZjpHwkM58FX6Y1lu39jGFLAKfqtgOzWy/FjoBfKd1RWviCtt97119+dRMPJquTNIcHCS5M/ljSiQZbAxB2ozdnPA/f7qVnMzMbZcRm4uOsuZI/vHPRl+mVNkgIfHe3O4wKzLMRp2YWBPUbWqyJ2MtXn4uADIq4tRaOBS5I8r1EAepg3JTNXx3ljyBVbBZMTg8JKNYUi5MqqQyTyi9XdAQ/jxwF3rSmdIHWRSqBTQGdqsPlbdBWs1p7tczPCb34CbRnDsPf2t8QY8zIaFmzW9IKuVXf5dHJWpmvRxImgTId+DgJZ
 jTCvuxDk
 peyZQ4iTiRa0Qhk5gRtHPE+qvK5ZFDK68hZbDYl+LOGNLPoEJ2NWVu4DLgpeLd/vnvoD5J/5PUsGg0WRm5+1m/HZf+fzpec+DSrS1VQ3tCy25vc6TZEiFRUjzXGYjdN14sNb/GHT/GF3WxBV/1uGkEgs+IsOc2O5IqScNMF+JShscrYBpKbNU1Qf3qJfrj1+suCvXXe5Gi8HBHBIEnHJDP3TiIlGqA8YSkcEVkG5w9mqcEWlO6J8L5Rz+g3MQXfWeraPSPwBJo6ipKIRrbMG48inqq70qJwAdFdaz4+y8xD3An3kfkEgA4mCo0Lg7g9bRU5XKn8jUqSA+8WnRYlH61LSgzbZ49vD7NEPt+5F9cSf9krU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 19, 2025 at 4:58=E2=80=AFPM Ethan Graham <ethan.w.s.graham@gmai=
l.com> wrote:
>
> From: Ethan Graham <ethangraham@google.com>
>
> Add a KFuzzTest fuzzer for the parse_xy() function, located in a new
> file under /drivers/auxdisplay/tests.
>
> To validate the correctness and effectiveness of this KFuzzTest target,
> a bug was injected into parse_xy() like so:
>
> drivers/auxdisplay/charlcd.c:179
> - s =3D p;
> + s =3D p + 1;
>
> Although a simple off-by-one bug, it requires a specific input sequence
> in order to trigger it, thus demonstrating the power of pairing
> KFuzzTest with a coverage-guided fuzzer like syzkaller.
>
> Signed-off-by: Ethan Graham <ethangraham@google.com>
Acked-by: Alexander Potapenko <glider@google.com>

