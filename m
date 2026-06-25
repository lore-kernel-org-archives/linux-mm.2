Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8ECB6CDE008
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 10:14:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 781436B00A1; Thu, 25 Jun 2026 06:14:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 758AD6B00A2; Thu, 25 Jun 2026 06:14:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 697BA6B00A3; Thu, 25 Jun 2026 06:14:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 373A06B00A1
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 06:14:41 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AD44D40676
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:14:40 +0000 (UTC)
X-FDA: 84918025920.28.068FAB5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id C46E920002
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:14:38 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VRifhalm;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782382478;
	b=jPj6rvbnm8L3+hcq0X3Qz8SchxKE1KJrLI9TJUlgaLwCwuXy+1kZAyLD496QKH5sra+v3t
	HaFvGYDfugpdKVVpZWLAdhCiZS3xmHE7u+TYZkP0eQZUztieqvId3u0Qdep3MA/2rVLw9I
	1QGoiX3Nmv19g8LaQNRyzK7CmPu3I6k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782382478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DRP4ZLbb5GsxegcYc1AO4X41kylUuJy9DWdQwt2k+T0=;
	b=eIMElIYOYZB17UHQt5DsFJUum4I0CXtkH1s9TTC2qUdJDCqQhNTSNCKqnERAF1NR06hFDP
	GY0Xco4WoMc1wel6cDjTKxU4FZYD4ubDw6+pfvixHF+iMGF+dqfOGy9qpdmH7LRIti2ZjT
	etpguI9eL3b2h/wZyHdaE9bo2YDqdXM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VRifhalm;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1D58F40771
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:14:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 019F01F00AC4
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782382478;
	bh=DRP4ZLbb5GsxegcYc1AO4X41kylUuJy9DWdQwt2k+T0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=VRifhalmMXDtsq25GbOzXgROVs0U2IrUFQz/54DrXzfYvnZb02zg4F9LN+1+Ahjfu
	 /JI11VTVDkOQI6WBwJbdG+dcrblbC/aJbzaMauofImJDo0bQGzxLOaa5JOoNSfxeOT
	 6RCyXD5CJK4l6Q3nb7e3wKZvboPFthP5zUjhLHAAYmWmeFG/xWcbmC1Ndm/1GW+7k5
	 mrm++RZr+TAVKXZ+6E7dXrcWye59G+RE8jy+Uuah3nM8MGjLdjtsinANAZn7Cv+FR/
	 QZYtC8kdbE79Fs3dYHT4nRK/rmI2FN2AAiJQ05ZOVjHaAKKvbFWj5o93z1K0KUDZj+
	 5J2F207No5WbA==
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-8de2adc59d8so6948026d6.1
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 03:14:37 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqaCC+9C3UTjKaVR8r7KO+8DFDOj4aC3at3Z0NPC9wr+e+LxVhiL37mWq0vkWNU+tYJF+5sd3cgeQ==@kvack.org
X-Gm-Message-State: AOJu0YwdXUobmOiPa+3K2MfertxbPTjkh+IU7gRUkZhvFT1LnZrtWtpn
	KTljsz1ij92+nLThLGtebWexJ3fG5aoDXLef1JSUwmQPbA0Fxml7BCPpedceC4g2Ji0JPLpwPc9
	Wr4oinmAMB48jhhPYiE1jYlTRXGxZ9K8=
X-Received: by 2002:a0c:f911:0:b0:8cc:f159:7b70 with SMTP id
 6a1803df08f44-8e3b76c5a3bmr127467726d6.32.1782382477437; Thu, 25 Jun 2026
 03:14:37 -0700 (PDT)
MIME-Version: 1.0
References: <20260623125723.2503832-1-dev.jain@arm.com> <20260623125723.2503832-3-dev.jain@arm.com>
In-Reply-To: <20260623125723.2503832-3-dev.jain@arm.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 25 Jun 2026 18:14:26 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wv6KC7QG9DP7t-sHzaPn-7nZ_K6baxOGLun3HdofKORw@mail.gmail.com>
X-Gm-Features: AVVi8CfNdy86ihBfdV5Nq3EqM-U3sxMKCUFuKwVZcc-XXzZoPTjGg27wRci_Ooc
Message-ID: <CAGsJ_4wv6KC7QG9DP7t-sHzaPn-7nZ_K6baxOGLun3HdofKORw@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm/mprotect: drop 'sub' from batching context
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com, 
	liam@infradead.org, ljs@kernel.org, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, baoquan.he@linux.dev, youngjun.park@lge.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, vbabka@kernel.org, 
	jannh@google.com, pfalcato@suse.de, ryan.roberts@arm.com, 
	anshuman.khandual@arm.com, david@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C46E920002
X-Rspam-User: 
X-Stat-Signature: yqrfuzssyhp7fxi9zpbpuxs795rzw1ie
X-HE-Tag: 1782382478-793226
X-HE-Meta: U2FsdGVkX1+92A03coGC0zMxL/gN3aQ+DgvfkqDMom97m5K5tJjJ0mQz8CQBRd8lkc5qEvBx9H/ivd22G1SOAV5ltj+aH6jEufuHUsEOJYSLAqZh07HIPs2ynhJDYnSZD3NN++6gqMu+vjr+z0mQ17vhK9p4JeiJBWFh451gOEgQGTBJ2vsGVawbQrTgEi7nguysXhxJbfWu9rbOEnH72bGLBP3Hil/1uSwFOrWxHX4d5E91WYrpwcN4kjXhDoU+uagS4vzIrAQTRgsZfSUgDLwlUQgMLLOk9p1vwwKPkN9AYi+Ea0rHed8tK9zC2BsQthQCmHEtS6HPX4zfm1IQvmK3VfFEkzCSTWrLu7mRTsWksk9kyoXKWXmJ4q4iwcDpXnAY6bcc+yjZ3kxN5uoSt/H1ZTmcl+hjMnNV1hkK0i+9Q2IlA4QCBPI7pToDg+bBM9BCvfcwTbKI4oAQNijaOochl/u1FmEPGQ405T3Qq5MdNLRj4mo4yfhhvN7pK7jLXO1WGMe5X/jV8m7CgGddmYOAa+f43/8qtor11kjqPekB+/vMXf0e9FpuZlgSMBkz8+8mib97MTHLXP48AbOM6N7U54IWfeIkz93MkYRP9pGfGE6XpMCOTF3eJxME2IP3wnLYfL6X9fEesvuseIDYLoPagYqbfrKmxZxQlDnEgeJCLcrb1iwxAa0TCgtYIWMr6hAcBJSKjRjMERRTd5BbOQM30lKukKKhCyreI23cxMUM8bm6LFqHLMTZ6R4uyZamM0fK+hjtGKZznOCh9UkQf8QENEdPWdgRrwvZUvllFSZlfVriA99uHr0olxaWlHAhVzYpLIt2SK9ktjtCWfq+Bq7uvEUiwKqrlOIzco4nC5Jap+clw7GGj848th+ceh97Up+ciaNncHPi4P0E8joPNUoJSq4K64VLyf0nWFIxEfIfwT0dlvaawwciA4wzaqdOPHYQYTfqLRSwuPLUboM
 RHIaF3r2
 wCRscMvOmnRvLAKj/eGmSgbpqZHxO3vibt7EduZebFrzzu0p+S31kcI4jd85liWK9CKCYLGkPhS2tqoYGRvGclbYjl/Wd47NWAdGZc5EobWmW29BT7OsL/zj8jlgd9B54M6rvbG8x0sfaf8UkKQe/++yp3dNCLakqlqYqIsMuxfEri0sw2v+1+vpmZik82tpATDfJCCCrsCWfU2j5xAiE7XWtA5i/lih26J9kkbzzL1Qg4oEO/b18w9tW7skpXeIIujpnhhzamkb5P3AxcGvBue6XNXlTq4Dx6jBZnoEFKjqEADDLJsYDmGwj3jiVtYLwsI3DNUGsNn2+aPw6vlxJMt2foqD4vVjzN65Hv2nFAv9uEzYPMAfjGSFz7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 23, 2026 at 8:57=E2=80=AFPM Dev Jain <dev.jain@arm.com> wrote:
>
> Shorten the name of page_anon_exclusive_sub_batch by dropping the
> "sub-batch" context - the function itself doesn't need this context.
> Similarly, drop "sub" from sub_batch_idx, it is unnecessary and the
> usage is clear enough.
>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---

Reviewed-by: Barry Song <baohua@kernel.org>

