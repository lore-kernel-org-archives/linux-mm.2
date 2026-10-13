Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06D7ECC6B03
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 07:30:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE1C06B0088; Tue, 13 Oct 2026 03:30:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C924A6B008A; Tue, 13 Oct 2026 03:30:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B802C6B008C; Tue, 13 Oct 2026 03:30:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 888A16B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 03:30:06 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EBF48C0AD8
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 07:30:05 +0000 (UTC)
X-FDA: 85316779170.22.159FCEC
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	by imf19.hostedemail.com (Postfix) with ESMTP id E1B651A0004
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 07:30:03 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=evbGGnll;
	spf=pass (imf19.hostedemail.com: domain of mingyu.he@shopee.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=mingyu.he@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791876604;
	b=bRmylwruTJzwK2s3ypN/Icv1gORtr1vfr6oHECvYK1OPwOWBspApw3CheOGLRm4kMmP283
	FFWRWTus16BN6U/8r3aVMkqItq+GyTDeMUb0Bg5TSStUUOIXQzR6AU9i3NbHBc2zLmDO84
	lhiXYMnWqt63t4bxQmbgTcpVA9RKC8I=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=evbGGnll;
	spf=pass (imf19.hostedemail.com: domain of mingyu.he@shopee.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=mingyu.he@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791876604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tC8SBrxY9rjxL+sOaV51qeAfEaErpyiM6k+xmWhrmnM=;
	b=B+5AX4AOsxIChA9OAzBUNJKfCaIZ8PVDiztzp42RtgZt9B49RBYcFaymE3jQyNeRgHgOGd
	CF/VVe/NrWyLxbHSGQDoWqa6DC5UC2tjQKmvz3Daq0t160zMVZZOKhwPAWg4W+gibI2YcY
	oJj0B53iyWJrRhlxYelUg5fbWHr/g20=
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-154e9d2d979so1776521c88.1
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 00:30:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791876602; cv=none;
        d=google.com; s=arc-20260327;
        b=NoIZ9+gZ7UJFK94P6VGj1xGV1KBBOaiqjJsMWbAjA0IDSYZMGIph5TC5nN2wSC8rU0
         HcR1KK8TO8TIfiQHKvP8sfkITaJAn8pQiVuiPPuN2kvlyrJn2gSyMEVCdV38WKQ7N/BQ
         VeOl2dqUqPlKs9De2ej333WKTjmmJ4ZM+Cv3PxrxQ8nP8Op11eTeeAH8bArZ1jq8lcwu
         nq2FK5C56slRyPX0MS4WptnpBlPPMslj3NoOLg0BYiRas0jMGtC3OqKXmpqjcqFmAO1G
         nHtoJJ9bBMMnzHGosIn0F56ijgikZlSz5ATWex0RC7IZ/ovH1pu4jDp4fBZRIe96haes
         Z/6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tC8SBrxY9rjxL+sOaV51qeAfEaErpyiM6k+xmWhrmnM=;
        fh=nPKnpu1KiujrPWCpaahzZKx8DhlcRRZo4n5SP1F89cQ=;
        b=G1107iJkRyC1kOnDfqm50t1ttqaG4UEUWMx69K4M8nXiNIWfIiK833RwEdwoo/Mr6d
         9oyavHZuAZPz7/whbZs4NdAvvApitoUf4E7Q3aMQASzvr0OmZtf8zTE3uH6VuSnaaHSG
         xHjSMsNOgTmMA6FBTVfs30AwcbnZKjWOxLoQvlS3M+DIBky3SeYfCR01mx/fsJEq0AQy
         lbMJob0qwvjo3N/xOmXNOIlWpWHWz+gBqR0bQC4N+s6bj4izuSu7QL3chokQWUuJdz2U
         N2gBJEsqZxEfRFo4FXrg8ehp9h6MbSGZCHEkHyOvvlNTxR0FYEWIpoo+jwE9r6cogwxw
         kP/A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1791876602; x=1792481402; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tC8SBrxY9rjxL+sOaV51qeAfEaErpyiM6k+xmWhrmnM=;
        b=evbGGnllwQA9WkYBwg1Y3JtNP7VPg6RcOyAlQNEuSP0FZ4qha3qB3hrY5KugrJEc+C
         0lrw0+U05P4jVfucFDe7kc4sjZvkuFrufxzjzzIWuPz/m4J+/KcNVI8hKU1M0V8rTTZK
         ZdudkiyXGdkzh1c+5hDm/dMKMKci2fxceHEYBU/KpWlNYEUS/8wkzOPWWKW8QROqZkxq
         uAHd4mJZexlxlVY1Q3iSg7t96q0BEm2w9DC35kadPUUtrHnH+XDxfrlaGxgjps3C3TK8
         eVSwELVc8cHH+D2vw0aiO8mfTwWqtik4h53ob6n/COAXM3ZOQ8DKjh38Hcjb7rBCid1r
         2xtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791876602; x=1792481402;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tC8SBrxY9rjxL+sOaV51qeAfEaErpyiM6k+xmWhrmnM=;
        b=oJn++mqGtRP1rhPJ4FOjSV71xfuRyYpV1K8rYHNN30DhtBW6VT2nUOCE28YxFgsGGx
         OYZ+xsYsprZq5JVPPKWOTGD+xBkzzUIuTkYDHayB+yLSyuylWG1EISF8ssKNt2h5xxnh
         X7PWYDNvx6tdMdaOLF32C+0AJ98ldR6uhZyH9dyLFlilRJ6YdWCGP3a+mcYzaAKomfgj
         onTG5UUzL/pxMPjtJJIOLowOCI+IjTsLJ9EWucaU9hlRrcCY65eQIn/e0xkaWK6ljmPz
         MzYuw/5ccF368IaSCTS3+tS+ZMpOyrNi9uR/D8QaNUNGNAs5M6MNulK177Y4bIwvH6Rb
         MYXw==
X-Forwarded-Encrypted: i=1; AKwUvBzKYVHb/5fbW4Yrtkd2IpMHN1jDRheJUm31l8RHousTSntmf0OFMNunXbzYYZ0FYif6HbidqoBs9Q==@kvack.org
X-Gm-Message-State: AFq9FYJPMjw9maLza9YVQ6jnx9B3Uyzf7Oa+8at/T/0EHZHHZJ5qUVlS
	XU+o62x4GXf0V04ucNZVWee1Qsj33ivfHn9mpNrEuUbef6j5AzbrbQHjXOEs0ii8IPS6rnDC5a4
	Umu7tqd3g3DfQN17yFImkXPX92o2rz7spdnSPO1Z7Ag==
X-Gm-Gg: AYBFou0TzT9rEh9QoyFTbEOxkN1amrMRksbQ/m//XlaAutw2YsPN5j/WZnBLN7hyIju
	7tAHgg73D5aNtNxGzO/RUg1eboNiTDnuSROldyV87yLgmzd2ygRJpV1hNXITR6dIaiWUMoZwp8v
	YfhyxXy/1GDH0lkQ+ZnD+r2F/zMy5BkrBRjvs3ipeIpJ9F4wRpm11QmDCdN9c1zXPY0F8+4szHG
	bsPVWa2SpCBX9PIrjclyfK58ZoKVb+MFalZB+M3VVsxUz/CaMalfSkk7NZZwlOvgt6Ud3DsSvqK
	VRjKsfZ9PkBPer6HNDDO0FBb7n9Tl+e/PzGwKAbZpM5RncJUC/Y/Lf2JiQOkgYwS8A==
X-Received: by 2002:a05:701b:42d3:20b0:156:d588:c881 with SMTP id
 a92af1059eb24-16a0adc14acmr16130258c88.2.1791876602347; Tue, 13 Oct 2026
 00:30:02 -0700 (PDT)
MIME-Version: 1.0
References: <20260911032905.63683-1-mingyu.he@shopee.com> <aqRXqcynCx88D2QK@linux.dev>
 <CAAoBcuS=sqOAPFr9Gda9aTwuCMHMPzBMEee8qvPNHtNxrRWKuw@mail.gmail.com> <asy_L2s1TNcN7bOK@linux.dev>
In-Reply-To: <asy_L2s1TNcN7bOK@linux.dev>
From: Mingyu He <mingyu.he@shopee.com>
Date: Tue, 13 Oct 2026 15:29:50 +0800
X-Gm-Features: AclHuK8tuWwzuYE6TAzFhuKrEA3w8k-lxLPcIe0Eb2-j98t5vXrnTNoFLto9mLE
Message-ID: <CAAoBcuS5VJwsYyw9=77SaBUf3N1hL8NfRtGwpBhmyUUhT4+T8w@mail.gmail.com>
Subject: Re: [PATCH] memcg: keep propagating stats updates to ancestors
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Yosry Ahmed <yosry@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	littleswimmingwhale@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E1B651A0004
X-Stat-Signature: 4mr7ocuyhnpnzbueijipucykhiu11e3y
X-HE-Tag: 1791876603-226743
X-HE-Meta: U2FsdGVkX18CK3jc7lom0eWHUdy7t47/Lt01txkXJzuobPrADVusYlQ/Mh7VEj1j433O7xiXIHGlD3MU1tN64HHoWv27LdgVlKxA2DVP3x/CJk6By6vMAC0UHGM7mRJsQibDsawv+vIX/v8aIXhpJiXKNVvjUKQhHo8P1tQVt7BrvBDbB3DKusG1QlYomp7a/HkvrmIdDONsc7BS0Sbho4dOmBJgJ6eTwkY57LtNz+w4If1mkdz3LkZXkVRgBMd9DeqE+AGVLpKOtVr2QoUKemNQhni815jjpMWskEMlko+GGutiw5v5AtgkJwSNYduwdDrWhON5AW5KvR70eX2znz/iVTlMPVy2wpkcV9szWflPPDkpcGiUioTD2Pxc3c+U//n0uLr9y/3j6IkGjt2GfUYw/EhqR8rJG9u3W206k0xftAETqqNGIDqrLrQpy6DYyDooC2s0H4v8/fngBVLo7782F5/IE+LkVYFNy+cNLgto9ly9SU/4DKmSO+DU676DkcN7plqwfGTbjoOnBpggOIb7+3sxFiJs1bbNPDJgHtl9BpA3IWE4Km+aZGWEq8+BvQNuDLTa2sGnivv4b4tpE0NCd2DeWax3qoB/ZmLyC+tXAHgog2jDzRrvzyV4uFarx0wb7goTuf53rak/jhNCyrmQaTmSOzaupb113Bab+do8rZ6bMG7GnkCh1uBRjyuEQfBcjD++VCCC74wF0tBQqgUNMbEkoGIOq4hS+2hdbNb2ELkETaLDg7ndohvSq/8Qg+x5c7xV8ci3QXM3zBQj6WKZ+t1VudTtKgDJ8lQb0zqqsXB6d9RgQXsV0kaeDmseJVoZjg6GScSZBgsaHJIJf3EwGiK7le2IJpDNx5ftDS26Q/c4QJk7XCinnyb3lr/dQyXg2wfcjkvAN1zNpclOF7e2n2Rk7xAAZSla0A/qBrwmuzOg4xoTLl33aJkdkZNcucG7XJfM4ix+h9Jg5gC
 gmGGBVdi
 ngijH1Odg06WxxEfEonXgyXe6EikiOkyDaIo8Ejul1sRIac+jecRXPmcAUr926T5nyg2oS3q1LqRXovC8hMNTrCCfFQIzrY6/4xHiDNic24kldCwX3aNKwVTV6yKtc+kMi0fRwUN8fLH5wf8jpZIBrNbmL2WezvNiBTTQzG7c7L6USr6ec/6ErACdos+qJfAY/aH1wIPQO9AacEiZAYelpphBLBFXTdeIrLdvm4Jd1Gpr164=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 7:08=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:

> Please share your custom in-kernel consumer. Let's not make changes in th=
e
> kernel for things which are not in upstreame kernel.

My custom kernel only has a few changes from upstream.
I just call mem_cgroup_flush_stats() and then call memcg_page_state() in
a kworker to judge whether to do a page cache shrinking.

> >   Regarding the BPF interface, the implementation in the tree I found i=
s:
> >
> >   __bpf_kfunc void bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg)
> >   {
> >           mem_cgroup_flush_stats(memcg);
>
> Let's make this force flush.

I am not sure what you mean. Do you mean that only change this bpf function=
 to
force flush, and keep memcg_rstat_updated unchanged?
If you mean that, I think this is a good approach.
But I think we also had better to add some comments to memcg_rstat_updated(=
)
to inform callers about this behavior ( maybe has a large data flush latenc=
y).

Thanks,
Runli

