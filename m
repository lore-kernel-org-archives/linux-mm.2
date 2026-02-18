Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD20FE9A03E
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 08:58:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31CFB6B0089; Wed, 18 Feb 2026 03:58:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 307EE6B008A; Wed, 18 Feb 2026 03:58:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 217C56B008C; Wed, 18 Feb 2026 03:58:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0ECA76B0089
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 03:58:52 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C07F21C265
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 08:58:51 +0000 (UTC)
X-FDA: 84456977262.09.CB52B06
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf12.hostedemail.com (Postfix) with ESMTP id C5F4140003
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 08:58:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HTHj4AGe;
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771405129; a=rsa-sha256;
	cv=pass;
	b=S3oJs/Pzqbq2VDOmV9saDS5dVFfrtbbIqABKs+ifmgIDivgCMryMlGR0UNE1ny78+urb9a
	69dGHF2QjT0zCbH1tl7ivr5aVOSfdxMPMiC+0l0owzFguTM8UFWx4AEantYVl0VkYgi94q
	siU+soEoCq5Egn8JzfxJcesOlqsfJ9E=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HTHj4AGe;
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771405129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tvut1BfJ3cpazddpdU/nRmz0yZV3WbQMIAmidpNOpcs=;
	b=JGnJblvIA1Lq643aEAUrLb7ZpgC28AkiieeqQowmbOvlaAm++AyYiljBkbHlL8E5QZjHGJ
	++wUWvfrn0G0syiaSvmTUt+dm5dH/FnqRAaB+L+6hHsPSTa31V1xzYxLl4gjRmFBnEVhNw
	ejvy8xMBefRm5dClRqwW3yoysGtsSyY=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b8842e5a2a1so655983166b.2
        for <linux-mm@kvack.org>; Wed, 18 Feb 2026 00:58:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771405128; cv=none;
        d=google.com; s=arc-20240605;
        b=adLg/c0IyIJHsjHb7HHITwiwpGYcj4DHz9WTwYp/mwcLom12ywPi+cKr4yAfDLDeJR
         DyQxdj34/5YiTQzLRix4gfM5IiGNPbfdAa//AgtQhaAy2Up8n5gL5DVmGpBpE4sLHl7f
         bEzAzVIC3jJqTkGKOEMYd6DaxnuNWdsttbCvHtpQpOB0Q6f9PqCc0lLL6py1KUB4polM
         x2+p+ocaiHCDoSp877g3vgW4lt73OYFrdVMBed2F34VeS9Mqlu9Y/boAAFi0iJBTzksQ
         sPAHlhouLrEOgvGfodS9nNlsZjnDNj4ZtN2RKWZ1l28LOThmf0DBFPggQdqH4878FMQk
         r0PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Tvut1BfJ3cpazddpdU/nRmz0yZV3WbQMIAmidpNOpcs=;
        fh=g4nY5sqpwn/SCbPLxI3Y6gdc+TSkV6C/UOqukmREBI4=;
        b=kiRQDnSnluF3JzfBaCBa9zees1ZFsWL0IRh9+EPyWUxuML6D47ZhTtznPTrAyDO8Qt
         h9CTIFAnEKWWuI3ZPWne5z1yQ5bOyHTyyQLBIlHJ9ZSXroRSfxEZVrfcatAzAi4Gdm9F
         d2apWFUMvPdalcBk85l8H1rL4geLmRppfhvP21EBG2oHlNKksA5BLvudXY9dlTBJl6RP
         3F8ptcCn1DMRUL6AFslQMmyicQ72U86rssyLQ5S1cACEOoaZbZJVg6S/nXs2iVH00fft
         XD0lnPikJRBs49StSapORGSY/Vr2R8nntDccUzkmkN8kuzA79ffohfX0wdS+/TdgeZqc
         puvQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771405128; x=1772009928; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tvut1BfJ3cpazddpdU/nRmz0yZV3WbQMIAmidpNOpcs=;
        b=HTHj4AGeZBVAlbxJpeyhxg/yI9yCL+rJo22O0Ij9QHgO7XQNsJlXQJqBFFcraNfJbM
         vNbShNfgmCQV10o9UpyiaFLyuCs/oJa8QUgZj7nHwgg9eH5WkOQ3zJoVQ1lH6wFl4RH0
         7y5DNnSBUGO2XKLSA8BDWGlUWhEN+0F/wBEbnRDQy5gqBVxqIvMlTMi/+w6m/HIRNlzV
         yA2I3d9dtmeJ+roMUkqLI+7yPjFfOeGvFL0Zy7YcOPHSyejpsPOn9AHZu+3MmVJVAu68
         JxcVBwIU507++ow6nMkr6OVBOLSLI8JIxQaXiZhptkbmvRA60KkzGn7zG4L4AnOpjJmd
         heVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771405128; x=1772009928;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Tvut1BfJ3cpazddpdU/nRmz0yZV3WbQMIAmidpNOpcs=;
        b=p4+vfoDP8e0glkQ3tcc8TXJsbwAzloTge2oVuOIfg/AZP5hfsFMyyBGhPKOldYqk6X
         mRjnwNsdZ59mllWjszaOHm5oiPFzrezqV1ZI/7D/YGFlKM1HaaLifOsYMbcRuZNDlUa/
         /yP6W4inBXShKa+ypR6BnzqrSULdvUgWXHnKmdVQeDgBgVSa85VqBDJ01IDGqBP+5QRT
         hgLC0LOXUtpPcY/2g+WxtFPLb5l+Y5AF/IRuIDmt0nJaG9y5CtOGEMOj31k0XRS+/b67
         beKHs628LgKM48H6da4pVzJGZA9bFiivFJp2Ygkqp7pa2p5yaAJNOdI2pMPx2pURNKXR
         oUWA==
X-Gm-Message-State: AOJu0YxFG1wQp8ierAXt6jWTpdfHnaQdI8YVjciPpolFWmFjVYxWpWgk
	/MoL7706DMgv0BxGthN26QmVRHkEI8P9yv4aqAHMZ9P77bPMFvkO9o4MEbXrKFaP/OJ5fM8YehE
	eDziVPNcDN/Zk7CEn0k4vjhfV2cuMTEU=
X-Gm-Gg: AZuq6aL/IhvJYWB9YwOAk5kvnsRr/iORwchpemtu+skpQQcrrrA+JmPjBNoiW2MfMDe
	8zmOFSb9Tzaiul/Iib4Y2ybxLJreWdzVoxmaaoWIEH1rmNS1wMqEvjE47saQe7glAdUKJnfhaPC
	kLrL+uWLvTuj+GI0ACsFBfRwpgNDNq1wz1L96/qSNBDd+mSYAizEbK+kiASlJfIPKhHjbXKKqYa
	IgihihUStokMmjGCK2F3uf3tj9my0gk/cr2Yqe61v2qZM6ktVmVoBkOL8Ak7AYg6UZoXW0DA9XN
	7LlCbyTAWo56Q809xEMYavzFbrLETPKleorosW35
X-Received: by 2002:a17:907:86a9:b0:b84:1fef:329f with SMTP id
 a640c23a62f3a-b8fb4376aaemr897638566b.26.1771405127545; Wed, 18 Feb 2026
 00:58:47 -0800 (PST)
MIME-Version: 1.0
References: <20260216-hibernate-perf-v4-0-1ba9f0bf1ec9@tencent.com>
 <20260216-hibernate-perf-v4-2-1ba9f0bf1ec9@tencent.com> <CAGsJ_4z83AvzDNXFOY7UftOAkPcK+6AoR2rE_2rzQLTqx400eA@mail.gmail.com>
In-Reply-To: <CAGsJ_4z83AvzDNXFOY7UftOAkPcK+6AoR2rE_2rzQLTqx400eA@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 18 Feb 2026 16:58:11 +0800
X-Gm-Features: AaiRm50JBT6LZj4if3-0mAdpnUKWCt8vsnCaw7Vnh_a3smSA4u8vVHCPWn2aMxk
Message-ID: <CAMgjq7D5P7n9z6w+MbQGXq7RY1iTpwxztVOd4B=tiyXDbNXxHg@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] mm, swap: reduce indention for hibernate
 allocation helper
To: Barry Song <21cnbao@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Carsten Grohmann <mail@carstengrohmann.de>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	linux-kernel@vger.kernel.org, 
	"open list:SUSPEND TO RAM" <linux-pm@vger.kernel.org>, Carsten Grohmann <carstengrohmann@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C5F4140003
X-Stat-Signature: 1hu4hrthgsqf9j3riip5xkeomummc1fb
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771405129-456481
X-HE-Meta: U2FsdGVkX1+9TMU//epQGyN7KQSwjmayJPAEGJvesNqh33IMdpCg+Mkpa5eMumEu9CTYlvUIFVNjnG7LjXPobNq6VrOnjpD2niTItdTNtZGb53hCDdcExvx0Ol6oBNMe+vXt62VwrivHGut2tyuiA7gs0Z4DLyfFuNEeKm8gHGsWw+8CNQ9aZcsoeMgrLunvkNDgbI17aoatt7dAhMiXAfh7BdEE8LCdC5HU8M1dXyUJHOnz016pZviD7aRLNQSxDOWKQ3HDl1B/4h9Tu1gcL4fD3djBmXEwl9CUJWW7srLyHAem/gUMHmszYK6c12drfsrIfC0CTh5cSSfsUMgddaDSQ5bD5rxOgCx/tvS4qFHeFlvwoP6n3MMMgu8zSYNClfc8Zsik2NpRpz0zHkyZa3G4x2rpf3YLSvuL4bOO2xQgTQ2iuuW7OrZOSV3xU8mjPShtUhuEYA9uF5bezlqvC/PKOAl6K7YwWRg+KlDxDW5EgrG2GMHuX2YBTBx2HLwlk9a3osNwgDYEkarstHkHr1MZ3fvywea2Q3AXT7VbHuEYLXjW7xs8vhUSvF1IJ1DENON/PdO6JP+Jn5gdXrsGxXbj1+xcJxLW0ih6nby5FsPvUuYsVA5nqcvG5H10Wrd9uDSZzgj3XHYgmOmS3o8fjrco+TEKs5C7mzYPd+Bel2M53lW8kN9/Sd400Tv9rfdz/nmR9ObaSln9BDo7tJddYAGugIDXxJgdhLx4EfBE9N8uI4v9xd02UaCqwAtVBUu6vXBlErx7kHfOuuG4WtsfGvTB0s3oPX64Xy0DCa3wp1gVud1vz9ShHvq0A0ViyMIrCIjknK0knFI7WXeMvHzKp2HwoxGlM7DYYhTllUnNX8W0DMVmEms6wUGyC8gG3Phd2GtOokm6poHOWdEcccSmgYE/14dFqfdANZV5mXZEydPgQ1ts4O8pL+SwjIVUbFtRKGcXzVcHmqaKFjAV32R
 khBe7BQf
 LAxf9hsSyr2P3Mt49cX8ILMYz47kEe4dV35CJ3/68bh1TYsFKUvWwf4GhVhr35HyViXTnv8TUI7LMhz//Ejf3eehBRQi9l6SglaU78vG8MykeHPdeQxy061TvA834uGqDHeTFyiXEHF2BVIpQfCHcjdvanpZtYjuEfIz6nKacy/4l8lUajyTeZEXks0SNCX31pAIskPdXlza1CZZNoCM1XICwXKP9whQ0IH6bisujsPNMnfCYSR6pDrp4EucG/It92+aLfoZdCuo7EKm1maojyhm1L9SH/sHC6wMn32CcHmFtICc/7WM3TV6fBdT94FhgEai/fUTPQv2qQtAzNuvTcTZH44oe+bvHJNnm1D9T93XFYVz84cd3Sh0mu0L7ZX/2NqJBnUqka6EtWV+3Um2R+SDD2Dar0guIiQJaBZgpJP/48OU9cRZ3goGaYeJwVGAIXTJ3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 18, 2026 at 4:23=E2=80=AFPM Barry Song <21cnbao@gmail.com> wrot=
e:
>
> On Mon, Feb 16, 2026 at 10:58=E2=80=AFPM Kairui Song via B4 Relay
> <devnull+kasong.tencent.com@kernel.org> wrote:
> [...]
> > +       /* Return empty entry if device is not usable (swapoff or full)=
 */
>
> I feel like swap full only affects the swap_avail_head /
> swap_available list. Does it also make
> get_swap_device_info() return false?

Yeah you are right, full swap device doesn't affect
get_swap_device_info here so the comment isn't that accurate. I'll
update the comment later after 1/3 is moved to stable. Thanks!

