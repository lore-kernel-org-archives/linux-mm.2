Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0FD9CCF2D6
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 12:35:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C7F76B0209; Mon, 19 Oct 2026 08:35:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 152896B020B; Mon, 19 Oct 2026 08:35:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01AD46B020C; Mon, 19 Oct 2026 08:35:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CD49B6B0209
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 08:35:27 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CD43C1C3F76
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 12:35:26 +0000 (UTC)
X-FDA: 85339321452.07.FA01D3D
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf11.hostedemail.com (Postfix) with ESMTP id E60D640008
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 12:35:24 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=X5fxwRG9;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792413324;
	b=PO1su/q7WxiEeOhxiHZbqhoHCsaGPjUs2zlFpMAH8mDBQvytTzuHuUTNjIgFw2veK9Eg8w
	+V4b4Rc4b7BWSN92iFkV6zf33kSJ1QEqoL6drJA87y1bSh+u+utQRdRuYITElAAH4f5Fj0
	fNTNUI8nWhNFBlcQxlryK1xgMqxBbr8=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=X5fxwRG9;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792413324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h2JbWnV9rUc1EeFvFy7Tjt14h2irL2wrPatMAzjOJ7w=;
	b=zFcplFlGkL6hpus5guExWc1TMKoxByxIUXFEgRK1TkNPVNXtVXgi1l+YLNGhtoDWcLK6yt
	FKlOqT8rmuycUbl+w87f+mUkWhUfaDJ7JMd6Q2WQZqTSw8pD2RAzIj7UZxnRlDd6qr3Rcl
	++Mlj2DaQaora45Ix+PCaMFnFXpCEiY=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-48af4d4e61fso1226111f8f.2
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 05:35:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792413323; cv=none;
        d=google.com; s=arc-20260327;
        b=tB02/7e8KWqnpitX42rk6UIDq3I8fSBttLscQh3qH2dBJ53Af+obHQYorJloVa/LoK
         OfQpYR8STkb08I9kWe1PwGF+1epgu/lP9LJttjzcZ7DMq67hco5sbDWgM+lu2P/St7yJ
         557tokZkSSEwct2TYtBglrOqnH4GYYNKq5RVYQ24rFHwBpM6Ey1DehfdSgfqBdmOoSd/
         vGVrEHRrEcW10NesFCq7e8L7/T15/Mpudh9iGXN19HC+SrjXYYYLefQIhtngsnCf+Rct
         pxSZsi008G1WZ2J36EQfHH/Ei2YX4ZEcZb8zEdFgxlBsJT3oKHceYQgpNVVSsH0mgGWs
         /WoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=h2JbWnV9rUc1EeFvFy7Tjt14h2irL2wrPatMAzjOJ7w=;
        fh=3DBQ+XLf7CZldwfya4rJPzT3a/bC37NbuZasXXfxwM0=;
        b=YAyRXiIKeuwNWznIJKxDmaJmAu0DYJuTd1NbX7NE3Up1vYDC2BKZ2acX+zvRc1g76c
         UhM+TYlP1KJXe+oaJtmzpX+4WywnlytWKnNBbKynzKCWlQE5Nv9/iXAnaz0EYSClnLOu
         cfgyOfQfP0tWxVi68tlws7NmsSfqZ2olh7lHnbodyvT7aLteGFMCoOMMiQRCwbHhA0X4
         C6keYxcE+Y3c/OEDc4j1h27njzxC6PYuaCa4mjZZTGFgMxqQt7wBbmSNzhowZMYufL3T
         gwOOZu0nU9AeJulnKMNjqOxh6w7DqSjqo8cFh0cbAInv5Eiq3WwxzjeEBvODci2LsBEi
         Nbrg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792413323; x=1793018123; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=h2JbWnV9rUc1EeFvFy7Tjt14h2irL2wrPatMAzjOJ7w=;
        b=X5fxwRG9Lvmml7/1rNXcMelbS0MK9w2SobPNDXRf5piOMJmJhJV7LUnDy1UfZZaYiD
         LSVJttQwW0C4tZQsdsSqH+WnHBrWsDwsTgZhqtb8lHUYmZgHRU5cAydFAbiw6RE9hOcs
         h4W3eumnDziPjUw3BrZDfkrvyACh+3f0/zGneuC4U8BmEt5JdD8p5N9k9aAJVsQbqqgH
         xdJ1ZK6jmWoKkgBc0IqpsHtE3tzJ+wqqZ0TtxOV6soUofo/RdHuv7WsfPxYzap2XGhrn
         FZCFi0PTLIaDJ2Fx6xXsmuu5X1BJV9VGOoUGdvtqmoJHL85B2aMcegPp3rYKjhRwaKyE
         qdEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792413323; x=1793018123;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=h2JbWnV9rUc1EeFvFy7Tjt14h2irL2wrPatMAzjOJ7w=;
        b=uxzTCxOHY87Sq9OiCmQqGDGbCXRhZOS+W6f6PdUuRoxNPtFqM09AR41ENRxHe6adic
         6OuxsYEVdGsVCHQMkxBsKj+4l3JrZm0ukN3S9/AgjRjsVxQlEFh2aFD/jUDSaFZy9tPB
         xOwbT4UO030h60iJhZ/wT7LcHCSrRuDF9JkUdYm0aFPuUhxB68ApyoOeSGG8INMa93hz
         UVu82DwA8d8+PBAGZivOy8jHlAGpu5n39iPEonydglNFfnBCUQt1zE72vmdCRmNDd8A+
         HI7UTM89s+0GbN/nxQXl7T/dkSXNKLmVxZYOqbzDu9c37nJOTv/XJd0rgP7eIOeP9yNP
         Y6wA==
X-Forwarded-Encrypted: i=1; AKwUvByM3pF4lA/etIHVIK4HdVQgMJAUHqV7nTy1n00MsmNrd258hP3mqGhDRc3z2IB9nIC4P1y1ip607A==@kvack.org
X-Gm-Message-State: AFq9FYLMEERgcvJVzaqgWmiCHfnTDHPPH5QLvv443sds5x8WhbqWiaZo
	8UBL93XBwgKJlzYnCdxw3F7yQtM5VOf06PR2Bc+mA5UeOtrHoRjO6QtTMh5alSccVHJV3LjfQQv
	IWuHDUJVl1Nc33z1edrZPESrAmBu2jHA=
X-Gm-Gg: AYBFou0MhnoORf8bQ7SCebkgasB+nrTiOQZN8wniN6gVCXB2OtoeXCppWX7MVafYYcn
	g57F1ZFyGld/5yHQjDR+z/OtNjZfzAZui9h4zRQ0DWmCW3LusAG67mvR8cJxnV5g1vOU3n7KWNy
	OqU3o5ZioiBvRKR77hRk7dYCv9nMT8JBsyiUsaDBAPosAS95yjAW9qxvsXHFf0e0AuAoUvnAEBI
	R41p99Aj4fl4514T+DwoX7d2J9sqzXGtoHxhYaXcODh5tuSPMWbBeTZGEI5hC6XoM74+3u71zLb
	yI2uf00fUuM/k3ymwstULeXDWNncVuQWZvWhtnTR0Ajg4oHUukMWkw2e24Y3aM+RWQXTTZcBkkk
	XqJDJjZC2JG2MhjsAxhsS9keT3JlJxbLe+x9UUDEYrQB4iGjNc7WtWLRNC8SX+5qtBS7Owo0=
X-Received: by 2002:a05:6000:220b:b0:48d:ca32:e90f with SMTP id
 ffacd0b85a97d-48e07fb8457mr14720830f8f.55.1792413323141; Mon, 19 Oct 2026
 05:35:23 -0700 (PDT)
MIME-Version: 1.0
References: <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org>
 <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org> <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora> <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
 <5c8a2b7b-b76d-4bba-92e1-ec3d66794273@kernel.org> <20261014195354.GA371161@cmpxchg.org>
 <CAKEwX=Mwc+D+AN-B5T7p=80fqCDijdsiJjd6aN_3YMrEQjyvwQ@mail.gmail.com> <a24ca7b8-8b42-43f3-ad72-afe62f97f76c@kernel.org>
In-Reply-To: <a24ca7b8-8b42-43f3-ad72-afe62f97f76c@kernel.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 19 Oct 2026 05:35:11 -0700
X-Gm-Features: AclHuK-Ym9EzJ2CIcu1okawbU1UiB-xvQtvgaUvkzS7VoDFrSu5HhWBluHPj1QE
Message-ID: <CAKEwX=OdbOrFbdihntP3rmcWJUyM1UpYa5n+pYjt_feMQwx8yA@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Kairui Song <ryncsn@gmail.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: E60D640008
X-Stat-Signature: ie4t7jrxobkcdrzntzmsr5yeytjp4gjn
X-HE-Tag: 1792413324-447180
X-HE-Meta: U2FsdGVkX18JNoSzKR0PSOGekPx24ZSSPvvfyNxgB+JHhV+8PAbkmnJ+NRzcjo4v3MBR5supPYY7N3HI5fFSudkKUM1vlrkla2IWXiA9fH66VM8RneUHnnpIH1lmLoOCuSZjcuTyYYlUnfLBweM1i7p6t3Lm2ADhTEwkJfX5Ki7ynsZ1GdInxvGezXLMoSa0R28RPMZsDE2VFzayGJ+RhmJ8RWeYplFGWNU7Dv6u8T4IRJ+PqOyQGMFZRMXZnXUJ7/CCd/RxlB+Roc8vCl4PZIlO3RnoiEdIMzG6jC60/6QLsC6fBV5TA+70w/Krl37arLSO84v6EcP437dpvvanzZJR2tI/rgakL1CtbYV7EA6hMiHGIPGmftLF7igN49mEmhPAi7OhgFoBJ2L1vXmivcR6bttYLpXVzrcTtHu9ZVxCz1kZBMty5phUkbgf9tKg5+Kzh2wWwSD5Te/8irjtR2nUwJ6Mqn4uqYQUpaxwyFnhmKZdFrJ1kDmrJOqtoO66EF4XGKd+jstkM/MkKE6pxRXKHJ60GPU2uIrJbMaHBoNAuWwaq9qEl5LR74Kj8506NMS5dLg0g9RBjyQc5STR2WkwrqXw3NGh6WVC0UqnCVQDTPcXqyjdlUxn2UFh1nJZIqtzMQjQ7Ikl4NNY+APgGFKHLRASMOIIMghYcuahd1bv/DVNcQFX29F9fx1cPhQ8hS2y3Uo2brXrEDtjJI8FmDAmjdicclQ/ILhXvFw+exxm8LYCwKqG58Uadc4WG7Pg9nkcF3Orkyu/RE0ItzInrdr54gfNTkrow53RN1hmtsewFr22fYHvR+3+tygAexsyHYCml7VbGR9y3QuPaxy/rXTfuPO/VfyotGcd2ez3wIOlRGWoBqlzTtuMhgR+Bs/RG5marKT/B4A3Oiwio3cE5yHQZ0Q83KGkyMarpRIvw07JO02ZSmnPlX2GznMwI2bTpu7bCFL5j5nPfkSTG6H
 YwVHfIfB
 /OrLpuvjTvQ6zv9ahtFSvXcf3A87iBYcQVvp2Rk46NzCBMZoSA/XtvqDKwd0dUYl2vkcVVRgQBee8tIFp97KvvCWfhceHum17Enfp3Di/Fi3gfbU9NoY6BRdQdhW1c0YL+u1SaL5vdFluuFyoBRxU8SFJspAXqC6vkJAT416lz8qwrwAl6rtiIZDD2oFlqNu0YuH+I2nOfKfMavqJjO17oCa4UTVnkP81qvOlao4WhSlVdb/4uIU0vwudr/ZLO7a+HgcDzoTafzjEDaBZy/pfEOMQNejg4AeNulNBU5y5wGZTTS1dvVf0B8co2Q4CV/uFRAUwsoVuN0H7ca6/eA2oZaU47NNAHXOt5adyQ9u+Ey+ccYXOjFXeeAq0vxqIwxdTsE/knZbhi1qEmqppEWmzn5WzfAyt145ZQ/8fX+27ZvWRmmg4LSmGHbue5Xz3hcqvIkef8H8/OIBiSfbzZiDMhg5D3jDLu4958mFXGURfe24hJzmBJObrV0fB08lvhXt1qJ1Hy2kIOHW3UNCDyfeULmw+BjZ1dsjvFo3b
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 19, 2026 at 5:28=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 10/19/26 14:24, Nhat Pham wrote:
>
> I'm traveling this week, so it's a bit tricky. I cannot make Thursday mor=
ning.
>
> On Thursday I'll be traveling back from Cambridge. But hang on.
>
> My plan lands on Oct 22, 11:10 PM. I should be home around Friday 1.30am =
- 2am.
>
> I could just naturally join that day.
>
> So one day later would work for me.

Would that be too rushed for you? :)

For everyone's convenience, this would be the time slot:

PDT: Thu Oct 22, 5:00 PM
EDT: Thu Oct 22, 8:00 PM
Europe: Fri Oct 23, 2:00 AM
China: Fri Oct 23, 8:00 AM

