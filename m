Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CDDFC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 21:35:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FDC76B009D; Tue,  7 Jul 2026 17:35:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D5BF6B009E; Tue,  7 Jul 2026 17:35:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2F636B009F; Tue,  7 Jul 2026 17:35:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C2B5A6B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 17:35:26 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 343F0A037E
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 21:35:26 +0000 (UTC)
X-FDA: 84963287052.15.09534CB
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4620DC000A
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 21:35:24 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZAk4+I+3;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf22.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.208.179 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783460124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6TvSEo37Ek9lu9N2ZPyjBCqwdDE/+51lgxZ/UejOrQs=;
	b=1Gh5VyEKLwG9uN72VhEu68T/QVagAW6mAYwfzH7mfcosCP4HWcWIUGgM+ZJScmc8q9Rr6x
	IRibWsDo5Ptvh/cSHGNgiimUSeT+0mapB+wQIWUAYz2hSucIi+BoiskMZ0upIhlmNbEiID
	fIP880WENrpvDICuYOkMG4X4EGGbQnY=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZAk4+I+3;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf22.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.208.179 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783460124;
	b=g9SLrIWUf26WBPg1LcOazyLF9XkSuoDJgmhSlyw/LvQt4sAMILYyyZOwpzWlALV4qZfhHL
	BIi/FBEHtdd/JbebZlyGlMFT0dB8Bho7gAhLPTGZmqfq+lhEHTWmF8Ry9DojMdgZijg1Hu
	dTuu9f2/eI5BR7Q3veJEkU0JY9jni2Y=
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-39b237fb695so152821fa.2
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 14:35:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783460123; cv=none;
        d=google.com; s=arc-20260327;
        b=V15/IkuCLHSooHf+SVkqLpXE3jxgqKYkNeAcAeVE0oo54+8C+hmBiJdhqgMmfSCuOw
         bRdIBS09gJeaM/I4DegjHtNICxfGMfzwab1DT0uIwDx2c7Sw1E8awDYFCCw6w8JdtBt3
         sR3laaX9LmBWpAIIQkM7+lcxlgSU88KnvJ2BY+QaWZ8RXUOCVRkOj3An8s5UA23/djyR
         iIZb7rBZXVZH3fcLe+6W5csApDq7v2/6OEDi0ZW0Tf/2oX+tAtChzpkeFTtIESzcT1z4
         OF9twFl21i2XVU4tSsPBQDqV3No3ATYEc9Bk8XXeHkxXQqR4ifdkeohHDgdrHxEWJRUj
         ks9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6TvSEo37Ek9lu9N2ZPyjBCqwdDE/+51lgxZ/UejOrQs=;
        fh=4Tpul4bk6ofI0DlP5zAOy6u8+YSZ90utt4pjlv9kZ5U=;
        b=nAFs3Z98mBuEPqITFaGk+497+FyC/0qN4FU6M4/3vovbbcSeh/OE12lQDdjsCDWpOP
         8fLagiE5Ob6BP99vgoOpQcX6rt1RuqY0dFku498rR18wNSCRLct2+6MhREJM5C9A4GVN
         1+qwb7FVGs60J3pwah3Y98vkdJAGdxPfYD4AAbrdEV02R/X6z0guHlf7qC8zKxTzJOh2
         xpquAj16Gxx5IJe7Sii7lIiO3bLuADacpFhUwouaDCFA1Zw2ujSaRzLEf0KKFGmc8MOZ
         149ePKAt5VzrNzbbtjE59ozuQx15sLfDsG7AyknfNfRuVWrIKH/PWI2KIruDAiCk1dnj
         YXWg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783460123; x=1784064923; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6TvSEo37Ek9lu9N2ZPyjBCqwdDE/+51lgxZ/UejOrQs=;
        b=ZAk4+I+38AF2V1tqTtCACY4AIxPC9Cck5OCxAnXUCQGMyQtGKru8Jt5WBuCIw6inZY
         rhd03p1rRzMqLtT6NRDle5nW+zsT15EdPio/M8bkfFm8UJY9EKrrzFBnJkuVgcXUgrtW
         BIQvwe+cHH9LA9fQA7GhhtjaRipx/IWqzLP1BKmxT8O8wQZVKIddYXUyoKubXWrrvbzy
         aWyKk4GnlGa2NR7vt7VaGfKIJQ5J0QF/Gh+ZCktzpeGzRU+bka4HbtLO5IK9HkBp05N+
         /6mUxxYBiqLJoMlDwvqN+fjD54eSZS01p7+TsdIwi4Dt38e0RN3CyBga7lxDZBnj5ycG
         XASQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783460123; x=1784064923;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6TvSEo37Ek9lu9N2ZPyjBCqwdDE/+51lgxZ/UejOrQs=;
        b=KP7P7akbRrRGEV7qsTiDuaNjZ/gX/99l5SVPbFOqaK4Vr17Kx1SiFXMv8PzvuERg4B
         +BSGB+OwxcYepuJa6/PRw7aQSL9PefZapqotTjbGxrot/VrfZIJCTsUB0umqqlPRmwmy
         jq6i7PRNhZNewbZ4JEcyKU08LErKSyaEYhi8EQv1Fu7DXXAWkX4LjUvNZF5h218S+c1Q
         KcITv09JG5DSWOi6y6oHgiCqRirkOP6yRYV/KcIUzENvlYjqrNNCzd8U4tFrWlTFNnu0
         BiFvIU18juasUeplfu/4AxSxTNJdYTi1TybE8uNQwLtzHdBiziKtj7ztfcAhohuXAD5p
         ju2g==
X-Forwarded-Encrypted: i=1; AHgh+RqCeO9Mhsmq3zEtFemJYvS9o89xEM4neku8OC/TWniTq0PE6wIlqDPBCuyGA5aZB2enqr28D0SsOA==@kvack.org
X-Gm-Message-State: AOJu0YwgmSyinbsx7uQ6ddSUSuPUQ9HenD0rMNsX9QWqD40pQyvPk3i/
	51pD8WRb4enrqbL05BvSkVnTImgGekOHt3N3wyuG29SyD3gVVoIcxO0Cn2E+bJJtKP+emnJ+9TM
	lGbzdE5eGfTsrAwwX5T+qMQx8RQfRoAqDHoCwttM=
X-Gm-Gg: AfdE7ckKnl9spU3DbG2PVxYgiHKKUuv1D9V+rTQK8KiaKpEzoVGwzPbcdLktHqpux9p
	XYCj+L7tv6CujrNsDhjvrjQJfXOKqGBFsxvgO2TvO5BGhS64Bh64dZhug1mDopSKVYuC9Ivomsw
	KadOn/5yRgdqibMghngto8VGdaa5xWtnq1uM1o3maRFUFRoqaVg7yU58xakIuc3qBhcE8TKnglP
	AF3MoEBBhN/71ZET3cltQx1xNZADrkWyQ7TX3BPXGKRFCk0JF9nLeuF9JlxJla4Wx2MJJG3qvEf
	kQ9PIk+Itb7ptQXImvbDqf1HJrI3
X-Received: by 2002:a2e:bcc5:0:b0:39a:cfe8:dcbd with SMTP id
 38308e7fff4ca-39c600386b8mr15519841fa.30.1783460122325; Tue, 07 Jul 2026
 14:35:22 -0700 (PDT)
MIME-Version: 1.0
References: <c0970cee-42c2-4844-b88e-229853f08e90@linux.dev> <CAO9r8zNJh65SZzdW8Cc8_8N5Wr+ORuRtU3kuaAX_DhLaESFYTA@mail.gmail.com>
In-Reply-To: <CAO9r8zNJh65SZzdW8Cc8_8N5Wr+ORuRtU3kuaAX_DhLaESFYTA@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 7 Jul 2026 14:35:09 -0700
X-Gm-Features: AVVi8CcuwF-DUySIS23BW_Gdh2R_ilIjcwqI-GE5L8_I55ZKEN4Gc8qN02pks1A
Message-ID: <CAKEwX=MMXdq7KTzcEgXfNt2L-eTmAVa+nijdyiujVOAhXQsHSg@mail.gmail.com>
Subject: Re: cgroup/test_zswap failed with "zswpout does not increase after
 test program"
To: Yosry Ahmed <yosry@kernel.org>
Cc: Zenghui Yu <zenghui.yu@linux.dev>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	hannes@cmpxchg.org, chengming.zhou@linux.dev, tj@kernel.org, mkoutny@suse.com, 
	Shuah Khan <shuah@kernel.org>, mhocko@kernel.org, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4620DC000A
X-Stat-Signature: sqst9wwxhn9wc54o8upxtk9xerspd41f
X-HE-Tag: 1783460124-513953
X-HE-Meta: U2FsdGVkX1+ltgmDvRFgWLLRiHtaxGPihg6A2Ynnn0fHgUBzaNFAROECBND/7rzXCCFyDRN1OkMocDj9Qm4rOboOUk+p00OkQjiBVOpC3aEJGQxeDQHZtBm1ib+pARc1emMkM9HLbo+gHR5LliMd6I9jGwI6kyZpIVx84cayxpmuyXIPXYWyMHRJKFQcsBjCWHEWbHeTKcClr4Gcal0ubyTrZttL+HGtjb3csuCwhkeYrGc4fm0mU5kqf7bjScy9C2Qm8usPpjeVydhUnshK6VfhyfkJGrb4lcTu41oJvs7h8g+G68wlPDB+xfwXxeLlXrECbFC8T4HHD/sRYhIjN1mhmIPMiZ7wTOmbbx13ZEe0m+fPW3edDqrKIJBWMJmFg/jQ3ZX3Z8NXVXwEtfm70GWzoixei2fmC6XayV2vIygdDpS7XysAOx1LHX2DFbnJeD9yLDtsfmE/kjVp5B2nniRaYZRiSDTAc4sZCoaB5bwmrYETC0g7qCfizbMOIAmZnXfB2j4GlCVYC7vSO+UZxw97CsvfJ718umnXlKA+rQSUV7eRbM620+BUfr/QfsVqS9T2Vpag82KfSH7C0YimzhDELrhHBStp+iWFB6AbcMa8O0KNLBMtrwtWNl30o+HfpH3j7pWMpdf0mG5jqJh+wxdRY5HfLxYKmSjjRUOFlL7j4wlPcFgPKm7C7GeC0823VBSYWyTxpp3+a/zg0ijQ0ly95sn8k4Ta8uwfMmicOUbVD38AfCz0tXbLUk9zBZcaVD006E9t1/IEB/7rPtWNjl+ZKDfCG2jMGeJsnoY79ayRoijL0LIbYTzxldVU/cWqG60vAnqEC7SPF9URwutVqEufferSEZACSPk2QfjY5PnjQ5RQECzJmFu8kg5VUz/lQVM6dLi560SY1x8PCMa/As3R/lzk/CD3xyfAW+0q+V+7h2Pjj3ayTvGMeMMweDD7d1L+b0PFObpQSJ8VKDE
 Hmlponze
 RPWaxo6ta5AeG8Bg2VsnHLpUgndSi16IvydXL/a71t19Z2OyvjE9zh/fsur9JyrkgM3QYh87hSBkjjNFEwZgcsqJDcUkJSF2jJVszIyK8er4wW2zRLl9Lxk9eDEK+2mC/tbSnb7KFOMYqwEKSiiHOqaKMygQn1l1YFGJi4IBsVl4v6D+FJ15rDt3tkB8aPmDy5QJsYVY+HJrLVb3ngpmB3HWMUrYzsGwrj3hXP2VAle4zZovLCAU9HWaiWw6WOPqxhHRdHG31q4T7KRMxjWxnsLF0/Ap1wy7tvj4QrWF4euNsVKcDm1YXWoTd49G4yJeQ70X+Hrl2VvWfv7i5O/TnPMomP5QxEEa3q/71AIfvtzHrolyKIFAsd9nXM0LSLmxYTCC0yxhRAB/o25qgzlA/0ok5WaIVReJjkjcTNzbHKV4MKuTdVe4sWLkFk6RRbgO6TljAN+EWu7+Jy6IxrUCGWxf8Zg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 7, 2026 at 11:25=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Tue, Jul 7, 2026 at 2:38=E2=80=AFAM Zenghui Yu <zenghui.yu@linux.dev> =
wrote:
>
> We were discussing a way for userspace to explicitly trigger a flush
> before, which would come in handy for testing. However, we decided not
> to expose flushing as a concept to userspace.
>
> Unfortunately I think the only way to "fix" the test is to allocate
> more memory, enough to trigger a flush on most interesting setups.
> Perhaps we should scale the amount of memory with the number of CPUs
> so that we don't have to keep playing whack-a-mole.

I don't have a good idea for writeback, but for zswap out, would
MADV_PAGEOUT work here?

