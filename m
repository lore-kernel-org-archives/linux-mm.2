Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7272ECD4F54
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 20:38:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9294E6B0005; Tue, 19 May 2026 16:38:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DA3B6B0088; Tue, 19 May 2026 16:38:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C8F46B008A; Tue, 19 May 2026 16:38:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6C8FC6B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 16:38:20 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 01A93A09B1
	for <linux-mm@kvack.org>; Tue, 19 May 2026 20:38:19 +0000 (UTC)
X-FDA: 84785331960.23.9DC0A41
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf10.hostedemail.com (Postfix) with ESMTP id D4959C0004
	for <linux-mm@kvack.org>; Tue, 19 May 2026 20:38:17 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=XKFVLsIm;
	spf=pass (imf10.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.50 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779223098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RNHrtYaT2ssFGIbGBvuTdTsSFVUxE4rajD3tzQ6hD+o=;
	b=GOA+880DN36tD3JfZeZFgYu04W9dFMm+QEIh39fL2n9l3rac2yKo8SDCDYxW+YVDbVb//2
	zw9Dfs9kahXRXscwVHwwpUMaGXUBxV+m5OwnHV6fMGqtEAHadGOQycsKlovKsKVV0CXZ9U
	T5H+qS+tTzT7micBa/h9mcMZCN62VZ4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779223098; a=rsa-sha256;
	cv=none;
	b=FPivMJhycdef/xbuzXDfqKf0nqNqF0vdcCC81jvwJNJoYavUX6hkKM2i25NbUHX8B6RrII
	mBWe6JFZJBhTKel3SaP9EWQclFk3mJSYwQ7KGDUhc10LrPtAO2R4uVZCiNfmk9HVZun1Am
	k9KX80H0DoCldWC7b2ewmQ2iVwHN7hM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=XKFVLsIm;
	spf=pass (imf10.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.50 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-67389cf78b0so9474206a12.2
        for <linux-mm@kvack.org>; Tue, 19 May 2026 13:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1779223096; x=1779827896; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RNHrtYaT2ssFGIbGBvuTdTsSFVUxE4rajD3tzQ6hD+o=;
        b=XKFVLsImb738qu5DnR4BD45vyIBdzuJoQXkDgyolFzat0ywE2g410Fdpl6eVPw2lW2
         iInjlSh2OQPY6XunZ0Yl7QmpjdcIYJZPxfz3hwHMxwklp7q9p6UgmQI2gVniaBsAn/Gc
         0k0t2TG3FkhSjZG0PO0O+Lw0e39/R26Z8RQr4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779223096; x=1779827896;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RNHrtYaT2ssFGIbGBvuTdTsSFVUxE4rajD3tzQ6hD+o=;
        b=Mmnu3UwJHDwgj9dOqnLsQIfovRAApj2+enhqsqPirMK1ad+u5tSE4ChSJbRZMLlZqq
         PER4SrER5jWB5ANNs4kWep9DDEHuwkhpEnpzmCgoOxtnS+CRGTWwEHdjxuSDXNqr+Nja
         aLRk1deXq8aIHVOej/QIK+aD6SKllHP6D6fglo7/yon6gJeHk9cfoYn76s1+evZjtPvA
         rd2/BQPOx3yB/6iNN/iSoP8li2K0Ms1Hvv7Yv8+FTPDjzSnBG/52kufUQT+1tBfytfhZ
         GT/21JN0Sr56qXDTd90uaGpJzox/AFaWRjyPX2TDVY8Idk/LcqiGBxyRBViHnYGgvJIJ
         RMMA==
X-Forwarded-Encrypted: i=1; AFNElJ/qvhTX7aJDYe1ZMB2gEMgE3khWO04V+IMdB8MT/DUyw/NUoQxh64TbI80P+rgkM599+1DNNvag0A==@kvack.org
X-Gm-Message-State: AOJu0YyhGPugTNt7dR+s/3dsdcA+KjD6ZINRez0yAb8RekgrppzeVJcH
	NXhkJTgN8q8FdFZRzKKHbM/EvT4l2VMceabMFlncQlyyL7EQ7nQvGc7C6P/81W01FnTXUY72INv
	L0G2Ihk6xIg==
X-Gm-Gg: Acq92OEwDXZolcHBWP5564HNOHTf2TzGcj/BY44Cn2/OialW5YA1k39wiPQylDqQ5AY
	gLFqjK6MKDqs82k8QlC5kxEaocXRrBywalYw7AHJtde/yphl89zXivX7IVu+B9XuklFPZ3AgIOA
	JU00Y7ezfVUvixep/x+rYc4zPeN5fm5/7yqbeAHDP0Q0wkYLKEBXntuW68dsHOg13LKfBa6omrC
	+lpt/qHGwlz5OvdUhwGHCQn4NYNPg6sR4dYeJq3V4TJzLvOYjWLyduVWS6p+3uKghb2mL+5ggZ+
	x47ki/dm3Lg3T+6Im3VK67L3o2Q9/h0IpQLWhs3h2HcajLylBB4CSEpXDYBFmW9s9cJfYvEB0st
	ZVVJf6hJwBwtVgeQJ5S6piR/TEzRPyg2IHsf1GA4kbLX2+O/74Jsml6ZL5V3XKQkKzAUNVg8Qh7
	QYXDjPKeHLaoiwwp6Yz5zwn8QyCUHM0NBVnmcr11S+29oP5V2CBI0IiG7rVJUT57cPv2E9CyOb
X-Received: by 2002:a17:907:cf8e:b0:bd5:7c2:70ca with SMTP id a640c23a62f3a-bd517a992c2mr1190224366b.48.1779223095874;
        Tue, 19 May 2026 13:38:15 -0700 (PDT)
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com. [209.85.208.44])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bd4f4dec7c4sm771482366b.40.2026.05.19.13.38.14
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2026 13:38:14 -0700 (PDT)
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-67e9b3037dcso8307233a12.0
        for <linux-mm@kvack.org>; Tue, 19 May 2026 13:38:14 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8rP7vRvaIsJMQpkcjCBQms8ohvQ5dTBwNxZokixbuJMV7aovZ/9KVKUFrJ6F4duvnRkEpoYB43RA==@kvack.org
X-Received: by 2002:a05:6402:5292:b0:678:93eb:c9fa with SMTP id
 4fb4d7f45d1cf-683bd094604mr11729034a12.15.1779223094548; Tue, 19 May 2026
 13:38:14 -0700 (PDT)
MIME-Version: 1.0
References: <20260517-tonyk-long_name-v1-0-3c282eaa91e2@igalia.com>
 <20260517-tonyk-long_name-v1-3-3c282eaa91e2@igalia.com> <20260517223419.3262de7c@pumpkin>
 <d4d6cf61-568e-478e-88d6-01b769d7eded@igalia.com>
In-Reply-To: <d4d6cf61-568e-478e-88d6-01b769d7eded@igalia.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 19 May 2026 15:37:57 -0500
X-Gmail-Original-Message-ID: <CAHk-=wgBdK5iRf1NdOuMT0-+sjxUc8QAU9vr66jBBzY6EFDtUA@mail.gmail.com>
X-Gm-Features: AVHnY4KL6sZr2VANjPBDeT072XXr6vvQupwTPfEIQuzU7GSuDKYQKMbqdbBGZ8c
Message-ID: <CAHk-=wgBdK5iRf1NdOuMT0-+sjxUc8QAU9vr66jBBzY6EFDtUA@mail.gmail.com>
Subject: Re: [PATCH 3/6] string: Introduce strtostr() for safe and performance
 string copies
To: =?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Cc: David Laight <david.laight.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Christian Brauner <brauner@kernel.org>, Kees Cook <kees@kernel.org>, 
	Shuah Khan <shuah@kernel.org>, willy@infradead.org, mathieu.desnoyers@efficios.com, 
	akpm@linux-foundation.org, Yafang Shao <laoar.shao@gmail.com>, andrii.nakryiko@gmail.com, 
	arnaldo.melo@gmail.com, Petr Mladek <pmladek@suse.com>, linux-kernel@vger.kernel.org, 
	kernel-dev@igalia.com, linux-mm@kvack.org, linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D4959C0004
X-Stat-Signature: ffyqa6pn4xm3mjqs49kgznfd4ixn7x5m
X-Rspam-User: 
X-HE-Tag: 1779223097-208254
X-HE-Meta: U2FsdGVkX19eYFrg5xJhWudO4cbv7c+GmPzJOClt0sN3CszLsOY3jdth/+NLI31gk8ik5mQwrJaUtZ7oSKaorKZEkq0YH8hiIRbSVTkOnrU1cB5lV9mMZEBebzpnFDIEyJQVc5gF6Cqhl38j/INnlItnyUy5B4KBED7u+E22VB0Bh9QPYU3eKRaFkNiNiO4QVleTAM3AXINa7cLoA8HMjJb2+GGOZssp4lpbV3T3r6jQQZZuxpw89rWTWhueGGoMVBWza0JucNdP1wav4TvM8syLhqY/V8r9CTc6bdR8Q+dyDjithQoOkpTkH19OY/DvP8XA8fs4CfD4rFUTcoywCInkHnHoEiWmzlGE+/bYsDCa55zhf3LYK9yFe/ewUORU8Bc4VdFqUSAhKIQnZetKHiE2kFnT/T+HeZ2p5RFzcFYGu+BpGZgfE3P2p9UU+4l5+d+kTYnXoFb/Ff9Txf4U1+9WqAagE6HXZYolhtLQgf9kOb1XyVACCQltfExyw3ujiJw9Qx4oD8HHkWy2rLv49GBkxMazOzxSjPv2O2Tpb7aU1qW8oUROOvrzzf56a71joOhw+m/a9S/UXmOTsNL24cuZx9w+31n5V4fFlYwLzDKDhh5tuauY/be5hHX5Mww8/f/63xSpJBPo8VAsyAb7yTLEWPv5K0dV4uNrmEOpNldzApv1pwId31y9d59yb5ltUmokwej2+TB2kP3sUaA39zni2c0sMM1QG0KZgD2qqrgyTjkUGQDCJdy/S0sYKEr8Oa0AcjZMbxhnyGWWBszKgicy3/1Rvu0s8dJb8kcFa4GaylVp0MQNtaxMpsUkeWlB4xzTAD1kitFQaNNjmOEiQlUUmI1XFFy36+R2bL76C2lbiKNyNitKOmxk0QPVVWHG6WMJ1GlPAKi81dbq9Ea583Eai2cc/Ouhl4zB82Yq0vRbbpCVYv23FhmiZK0BfFCwVEFB11vvjSeRiunf/gZ
 RZE5FW5+
 S4dskj9LACiskmPTr3gdM9aEomZkf4AertkTVDjikMRltawb2j9INM6PLKyVG3WQvq77GVrmNBw/ZnIz+KRt3P23TF9Um2VfbmUWG5dt0Da4f5OmcBUwypFhLO3lVzvMPdeQBjbbhqZn72IkjShnoZ8bIQhIl1nx5AlAuVVb54QAouxCGTAg1qTh9WyVRdiCoJETW/YVTBEycEJNV2FtqUppDxYaIftWLMez0nm7ShrguggXDRFrCr0PuivMOWFUgccw7jw18hfMqMacrWmUnTVl1q7WS9TKwlwX6oycRbqNnAVlivV+sQaQCRjD68h1AkewXCQUFuJ06T1V0+NATkhww+YcNZMlL2951pYS9YGweqxMzA2uqwt4zxh3IQkC2AfCwS+Ta7IPsofN441lDH4nmuLYDpYJdvCrh2mJ2sL9xnB6XrU7NHC0PlBWEhEhSGOVTxrDMDl3Po3D+IqbGEqfv3x4O633keoQTIM8Jy/aOgFlQXkJ5ssJkxzO3G3E7Z4l1ednJx4rz0MJGvSH90p+orGcdzUIfhCgfK6DdG5luk0AE99PD4Jip+5HM0g2X2uoQkRPK5abS5/kLz3zhUlrEuJWhLX38JKQ9I9W0nmuj7bkNmnG5fox2RLYEItRLA/uFzOBsun0nSqQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 18 May 2026 at 09:37, Andr=C3=A9 Almeida <andrealmeid@igalia.com> w=
rote:
>
> The problem is that as I'm expanding current->comm, the source buffer
> might be bigger than destination, and when we truncate the string, it
> won't have the termination NUL byte. So we need an extra dest[len-1] =3D
> \0 after the memcpy.

What's wrong with just using strscpy() with 'len' being min(srcsize,dstsize=
)?

           Linus

