Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73E20CA6002
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 15:36:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A0D36B0098; Wed,  7 Oct 2026 11:36:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 751486B0099; Wed,  7 Oct 2026 11:36:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 667D66B009B; Wed,  7 Oct 2026 11:36:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3E6876B0098
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 11:36:37 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B64A4402A6
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 15:36:36 +0000 (UTC)
X-FDA: 85296232392.02.95CC5D4
Received: from mail-vs2-f5.google.com (mail-vs2-f5.google.com [74.125.227.5])
	by imf23.hostedemail.com (Postfix) with ESMTP id CA7F914000A
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 15:36:34 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=B4ByKIK2;
	spf=pass (imf23.hostedemail.com: domain of jaeyeon.lee.dev@gmail.com designates 74.125.227.5 as permitted sender) smtp.mailfrom=jaeyeon.lee.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791387394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VIlwNxRfdBd5XK7k+Yn5qCHGcNB8TrH811M/2dEK2D4=;
	b=t/40DzXrhCRSaYIkVYehiHlOGk6saqDSAxhTREPLNpYmeOc/RDtv2oX4OXUC/emUsxxMbG
	Ez9hTIDYl3cqFwlug6O5CKKh6zEkJMi5cj6pX3cvWilj0UNmrZToICPt6ftDOVf5JsACXV
	/MeVn/78T1Hv3g5ZDo2c5QhinX+QUlI=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791387394;
	b=4FqZOEfhpqiWW//LVAazz0fsfJ4Jd1ONq4NuyG6UW8r/PoscZB6kozLzOQdyDQUARKM81X
	SRn49y1/lt1FnDfMFEB6Edlc0omp9vrshBcXEjJ2EZUyKkiznwFHzVn/4zvFFiDF0LaBC4
	ZD5F7ukaBfM1b5nPa9vq0M8yYOKOi8s=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=B4ByKIK2;
	spf=pass (imf23.hostedemail.com: domain of jaeyeon.lee.dev@gmail.com designates 74.125.227.5 as permitted sender) smtp.mailfrom=jaeyeon.lee.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-vs2-f5.google.com with SMTP id ada2fe7eead31-7c326adb66eso3657402137.1
        for <linux-mm@kvack.org>; Wed, 07 Oct 2026 08:36:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791387394; cv=none;
        d=google.com; s=arc-20260327;
        b=j6Idh2UjpAjKpykssQc1c2G4UXIlmh7R0pC0GY0En/KdTyjGCWXtuC7lmEA1bss8+S
         vmfQvj0uOKCaHFmD27r2zGc7Gg+XftRLKQw5CyNBePzFhuHaAQus5gZB8D+WZ4heT4Ik
         Ys6n5eqg+o+RIeShxk9eq/hSA7VG+u01wglcDvh43TFW4afwne7bdl07bQxAZvqYkOE5
         AUNFVQlBpOkcTUMgx9/i1Vb24kCubFkWH/zuY8D1JfZIh3bvMTau3DrHsQwhxfE1SW3/
         4SuqsT1HCjRyEkcd/NkN7+dkPuf71jvxbdgIpILdu2RFw8x7g+wDkfg0BPm1MOUcSn1F
         vk1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VIlwNxRfdBd5XK7k+Yn5qCHGcNB8TrH811M/2dEK2D4=;
        fh=Fti8uXtzuBK50TzGiBQfc5Dy0S00ONwY62/vEyBJkEM=;
        b=CtkK7outmEMMUsnTQrCs+NiVkTfcpPToPcfUucq822tQkHRiQ3nKpFEMdUKW/Zx3VV
         KizErzpyR7PquMjWYAWyg/LQEA9kDd/bb4miWREIAPANvunOarvP+X0ML27oLTwmi/mV
         Gt7UWfH//LhP9fdykZ4fBRHioEiF4oaMyrLhfuuZVX99xYObdSTOniy+TxGyvI/knuBC
         sExkmvejhJXAYeLx5NVncq+yEVcEjHRntD2YDmDvsvdsX8hCIrn+OqU+x2wDI306hnnd
         MACnN2OFxLJmp7nDV8b9rc5T42F96jb7qj2nyFgqwX0tHbsJAvSgyCmdpy2+TRA4RGXo
         Yyaw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791387394; x=1791992194; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VIlwNxRfdBd5XK7k+Yn5qCHGcNB8TrH811M/2dEK2D4=;
        b=B4ByKIK2KADFPcL8n2VCYTL+4p4Z8vvnCB3sXIsYcFkXCm+vGcB5ZHvd6y+fyNIqRO
         w9nH1rKwMqRZLrw2WpN3SwzDExojxaRxWtNtmtQUIFL41bVATH8nGa8EPcjw0W1UHzAk
         7DITC2uOumPPTm8eC10zqAKndAzn+5SUGY6wIkDEfIpNxEmWd+JjohjFZ+zLvtc7SBuX
         eqK91IaceYi5ncNZEm25FnqLIrVyPH5sVhng+G0RO3gqZ5+AN+7akDOxvtKob0v2M6se
         Fqg+5zpczomBosgc0gaq4GNKnxHwkqLfKJSNBzzL52U6dMSdRePQv27Om3VoPMdrPER0
         7PrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791387394; x=1791992194;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VIlwNxRfdBd5XK7k+Yn5qCHGcNB8TrH811M/2dEK2D4=;
        b=lzpjHelhQlfbt/9WVco+i+AD23RztjYXixOv5YOFmkJ1aHwjQiT2q3mknr10cDB2iP
         soa+HdH6CPnw3m4sldC6Z4t8lbYVjeUrhkdGCtm/lYYkjFhwCV+AA2YdUFKb1XKqOk1p
         QDjti+1GaSJxhuCCLe7vct55ubkb9jy0j5tBzs3kttd+stAFdYligdvJ3SmWl/JiLcsB
         GdVsMPLGH58OCwmoyuO9udkceGgTHKBChW6WE0Ncfjz4Yehljqpt4fr/2MCHjVU/i2uP
         T6E/cV1VorvTqLJiYmBBlQXrhMEMrw/b+/OpeAtKVoi25V9xpklYSvRXAPjaBICToMKh
         VpXQ==
X-Forwarded-Encrypted: i=1; AKwUvBwDHNMTALp4+6KuMlYrNkbtwew1E5m1thC4EpBtnOVFRVK/bagJs+qDVDSYzQMo5yIdPi7IoQy/eg==@kvack.org
X-Gm-Message-State: AFq9FYLhw0OZ5vSO+rjLn0BuEHlg8Be/g4rDNjB9NuEsJm7ux3dzR7v0
	P1eNpyNPZEnx4MU17hMyRI02KWKfddatdcOG5e+f5LGn/NiZtWUHa9qw6c9myYC/AYqEmzA/rfU
	cd1uQezgW8fKueEuwVizHbpUg5SgOM9I=
X-Gm-Gg: AYBFou2ilRZMvkzN4vDEXjXDufcL/ZiYb1V44OK0Uwy32rEZ+FW7olGN3gqE4cvRzCU
	SlQFVkQOKDppvN57lGGfAEU3hSdKqoj1tHY+z6jFpgPwe8s+doRzVthED2zodt4tZChcHsL80fx
	ClLDdj4HenDYoYGnlVZSgBDwnifhAy+Gi4/oApc8F3ycFlldwaU2BSdEGI8EETqTxwdcbtLIGAv
	aAuUySzi6LWkggU4/Ga3rwJTA6+nXnAhYnzahgxvzlbDSS361q9+i7+xLkYqJFypY6M+ypq0vj0
	ijrtlZICREPLPd+N7/O2622zPHPTFwQOPwMJ+IohjQMeGp9L9px4OX69S1rRu+rB2zTEZoS5CsO
	Q3MeC4Z2alv2v
X-Received: by 2002:a05:6102:c8d:b0:7a5:391c:37ac with SMTP id
 ada2fe7eead31-7ca38a0cc36mr934178137.10.1791387393843; Wed, 07 Oct 2026
 08:36:33 -0700 (PDT)
MIME-Version: 1.0
References: <20261007092801.35649-1-jaeyeon.lee.dev@gmail.com>
 <022ec915-62ab-40d9-8705-90692e75acfb@kernel.org> <ce49e816-ae77-4c64-bd28-168d8ca52d8d@arm.com>
In-Reply-To: <ce49e816-ae77-4c64-bd28-168d8ca52d8d@arm.com>
From: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Date: Wed, 7 Oct 2026 17:36:22 +0200
X-Gm-Features: AclHuK_qZVYeP9e6a3BCk4ZuXrh1Fr29YQchvsleR4vDz7zanz3IAHpg3zmw-tk
Message-ID: <CAD+X6aDjhCGt_Btw7pcoj8uT4-tiTHX9+wEQQ4yjFx1KQj11VA@mail.gmail.com>
Subject: Re: [PATCH v2] selftests/mm: hugetlb_madv_vs_map: fix TAP plan mismatches
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Guillaume Morin <guillaume@morinfr.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Breno Leitao <leitao@debian.org>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CA7F914000A
X-Stat-Signature: npnfgka1gw86c44xizg4jnb4e1d5bh1b
X-HE-Tag: 1791387394-997587
X-HE-Meta: U2FsdGVkX1+UZfg9I+KaAoTuH0U8bOmtLdu90O4ZT5/jOaQGlIEcd+5XV8h/UE8nYjpAKlA6TmVCzgSzYG3a1S6x2OwoKOKENEGIFSLcsSdp3XFhw5Yje6jz6NukvbokC6Z44M+EpTdDXD8L6zvXxD90WxQUhg7PbO3DRJJ++v/jSSLSw3v7PAtYvF0xseg5lkEY5yo8q12AetkTgieCe8L6pyhgKVwqkmB2bHMJ8KLXgQlD5tk2DWlgkplxV52k06GBdXF+PZDqnNoStxp6UtKBoxTTCthjr6j0j/hsVVyVfd1Za1LasSe9/my/so2F4Vf8+94xje3Xw3QCxWAGJbAruaOoAnFReZZC5BQWXORs/d44r7+j/7wI+aY6uVdhSEDFrukXAsex9fCvGtUEVUTBrAVzigNOXPOV82379lGkYSiQleOWpOARfneyZUQj5YYredNu1pFfKmwjuxvPVMbBG9sQgKWzSYJAm1XpvtTMQdDPo8/FakTkta7wjYqzaMLctgXUZ5iWtsv5TWLjbWZNzx0MVHSGFpkRGblyI5sJpEZZ16c9u+qW+B1V7iGU2oXPSWrFdJOGy2I0sRdiUQO5q4xjZFChn0LIYyIS5NfjF6gNA4XBLlVplDmG1AsfS5cFj3RU2p+uCG9lY8bvpoBsAbSoacO26rTK10YklRlyN9fiJEDCm3eAu395oNG+psll4gRCsXy5ieXuhetWxinEEeK39q2QUuZhAegPbFlz2ksvtWzAqmLZBaxpcyDY+NhhmCck3qEU+hnGd2sFeKGppQ+uq54jitlxMG5TgKBNDzI9e1gEoFC6VuN6kHl9jMKUoeiSYmDgBzcJwEl5/Q/iMOR5Roch629+Hzn7m0wwU/Oibun4DoYajUm1CTcAprNNLSzehIub1NlK2vD7z62/s03hiinwVxFqt7YK6+8DDzHx+6o0FrjlxcmUUMGoYc13p9EoulfbQtrcpku
 Jh9sMEPm
 hUInq4L0F9CVUnTRVCADG7M/Q949dx69SMHd08R6iPzkLGxwxnKhBlzdxon7/KPcmqm642qnOG0nINhrwFgWmTkkTTQGwWktWZ3QxXo+PxkmDPYAkxK6xRtcKZN3eMhhHGOh0FKVh4kdBRHvwNU2FcRxGnzrmtSjj6vZqD5YLDSmyj7DEnr0BruVfMbqFfAZKpL/VUEpzsLbKX5rMjX7sT6hswq6DZPbhhdXtnuXGbvnOyqNGgaCWvSiOsVSj1o7+XoiGHxWbpi5AQ6IQDZ8OiTFPaqldaBBxNrfXEKo8CFBDabLKWSrr3n8AiVcxsJOh3CE3yrdXARS+/gr2MC5Sbdl5mFbr2sTO3t45kuHRnbr703Pkt4jC1WrqUWkaKm4bYBrtPAPssNZYZ8ewSK4xY8Mn6aSZjtKClLOj3WLrg6Hhgc5o8Uwnqf4DHlzSYb8xi5ZSfVJ1urek9dnu1O0ap/QKB8jB0LZ7Kts2R6Kq7CyAXKi7FH/i0qe1jZQM9pyo3LyfBb0VwPgj16kQf1IiGbXjjG1n5prD8o6p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 7, 2026 at 2:01=E2=80=AFPM Sarthak Sharma <sarthak.sharma@arm.c=
om> wrote:
> Anyways, the original code also calls a ksft_exit_fail() in err_cleanup,
> so this skip is just preserving the TAP test count, else we'll get that
> planned tests !=3D run tests message.

Thanks for the review.

The skip was only there to keep the number of reported results in line
with the plan.

I am happy to send a v3 that drops the ksft_test_result_skip() call, or
drop this patch.

Thanks,
Jaeyeon Lee

