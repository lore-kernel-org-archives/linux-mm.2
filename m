Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC326C5DF97
	for <linux-mm@archiver.kernel.org>; Sat, 22 Aug 2026 21:41:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C1356B008C; Sat, 22 Aug 2026 17:41:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 872566B0092; Sat, 22 Aug 2026 17:41:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 763186B0095; Sat, 22 Aug 2026 17:41:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 50E246B008C
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 17:41:26 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C3EC21601EE
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 21:41:25 +0000 (UTC)
X-FDA: 85130226930.10.AA18725
Received: from relay.hostedemail.com (unirelay01 [10.200.18.64])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0477A180004
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 21:41:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787434884;
	b=dYyWVLeavKvMRqyLeHrWG+7a/Q/Ons1yza5no407TZZlr5H2HYCXrxpE1RtfgfwZ1r1K1K
	K1b6HZ5wHj6VnKdH7mGQdKvatEkZ6jqJh/CIrFhf77MQ7hrI200QDxYsOA+Ae+GPfEogNO
	03ungfO2278nLWATl1NWZDPJBtUIA2w=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787434884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dtSe3C1Tc4gxt6nN885cuKTw/xAqg6X+Lj8V/W6XzFA=;
	b=GkIylYTr/1nE2fVOaq5qaga9MOuXE9r0kjF6b5Sl12jTvpbrWxGwxoLgdn9vAdM/MrppCD
	c3URSsDg4jtJwGYtKVdD/E4l9ywov3lNGIrBSpXjnirrNXyt2SOxO9bzLy6LKFc+zoms24
	rVd+uH4QqERz6rBmJmjropYAXUzDZ/g=
Received: from omf18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 70EAC1C0C8D;
	Sat, 22 Aug 2026 21:41:22 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf18.hostedemail.com (Postfix) with ESMTPA id A9CFA2F;
	Sat, 22 Aug 2026 21:41:06 +0000 (UTC)
Date: Sat, 22 Aug 2026 17:40:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: =?UTF-8?B?SsOpcsOpbXk=?= Jean <jeremy.jean@oss.cyber.gouv.fr>
Cc: Bradley Morgan <include@grrlz.net>, mingo@redhat.com,
 peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org,
 mgorman@suse.de, bsegall@google.com, dietmar.eggemann@arm.com,
 kees@kernel.org, kprateek.nayak@amd.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, vschneid@redhat.com,
 linux-trace-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] fork: initialize function graph state before
 copy_exec_state()
Message-ID: <20260822174053.26aa2f56@fedora>
In-Reply-To: <603183e5d6abcae2229c61b8e266e60c@oss.cyber.gouv.fr>
References: <20260822195321.962383-2-Jeremy.Jean@oss.cyber.gouv.fr>
	<4E2240F5-1211-47CE-AF04-24E1F0BC4707@grrlz.net>
	<20260822170928.1acba2cc@fedora>
	<603183e5d6abcae2229c61b8e266e60c@oss.cyber.gouv.fr>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19BMXAzeE7Pvu0yytgC++z47nFrOeJ74ek=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=goodmis.org; h=date:from:to:cc:subject:message-id:in-reply-to:references:mime-version:content-type:content-transfer-encoding; s=dkim1; bh=dtSe3C1Tc4gxt6nN885cuKTw/xAqg6X+Lj8V/W6XzFA=; b=MPnoNiz8iaLPu+lNvzqdC+gYu2ZbtLvWJQTMz4QR06+RJZ7Gi8fhIgWPB21btFeWC3kayltX0OdCqN5Bknio6vGmHekRjxWHlm6xIZwx0rsunIPotv7INM14WrVIv+u5LrJhi/zjCV7YROL6kxja9lpXVnTpJ8p00g1gotTx29o=
X-HE-Meta: U2FsdGVkX19z+F/YeVL02ioTYmPD+aS75hp0rzfxU80zUVnxchF90tHh5jg4ATMUGvaWfzMOYjQktfE+vO5ogejJtU9HLYuFoffslp/90B23PGlakWB2fj6spMaAkv2ZFUQs9pU6wI1s4W0kc+IaO96YlPdU7DvwwokOhY19neUdLwp7ESgFWBvH9hr5Etcy1z9QYaf9g1MiwegSs0g7HVv5/lJgRKXbgohkH1OKpDQLsEUtLLgrsdnK6DPWpmi0o43JCFyTN/VCt7z4/6yRyGjAEJV2MdkOfRyGuI2Lquc2JqXETLFOwaI2mSo7Ocv6ivlAoElfzg4/MIXxPjoPn6/WyK4m9/S740fqJbXygm+YTFfpCb4MNNTwyxVdUEgv
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0477A180004
X-Stat-Signature: qz1pi3axyizt7u4bd14d7z88nseecyie
X-HE-Tag-Orig: 1787434866-292068
X-HE-Tag: 1787434883-194179
X-HE-Meta: U2FsdGVkX19ZiSdfy9e0UxzAnkWuvOLKJftO5jDuoucvuGVsZzp9idPzbdEULnpdXlQM91LCRJ1MORZff8dB+0Nm9adTrR26xWjwilVm9Ar2+Y1hfttMwW793/PufjlIBpfaJL3l9fJ2LoG8pI6w+Enma7HEjFzanSsqJ+kGRP+atw/kRxOVGDY8F/kk2prW6dQZGFOo4LiJFUQNjQYQ54DRlKZnpVim9essJfZvt7HbhCKOHWsTponGLrUOfucTSbfuNpFqU1XN2M8ZLsTff9pI62/O6MuUPfHrTDLuJ76ac+6XQJOju8OTTtRNUy8fVrJKdKeItz4mTHMsWIl2LbJL7n4TZOzd2q7MFfPM9wVHtFUMpuVp2HXQmUHq3ChSyvfFv/YU07hhd3kK9Smzas9Nu9GZjIW8YK/KSten2vxGu48/66lllm7DZ9cY1L9hbO6C4F7fjI8//1nbeykdnbPOs757Nj5+1DB5xEPZm46kVSCFK5v03CbZ+2T18aLeS8CyH9Luojc3MfWFA5JMv57JMKLOzEjSAODjwuw9NuhY2gBaPAlIw0OIZSMJpf2qtcWWKXy6GrnEuwcYgcebEn5DhvgjP88WmfrDxjtFNNgVm+Y0E908dGf9sih1ZeH6QTBBFPO4x0tvJvn8Ah9wND1pWcCZNxc5DOL4+ZUc+aAvjIhC1Ih4BuJHhII0j7NCPKFd18+q0wNP6oDBfOo6o9RBOt2d2BAVe8laYyBNf4WZTtkC1eiohKUb5XHG6X7L2q8D7YVf8wWZCegtP2XfztGK2DhPpqwnbxHRNMDmjS5avE3oFEtpTMBm8EXCofrIH47GZI3iyARUTxdh38afRejHuGuKaHZBBgY6Tq31O+rYL+pzXfhwHyes79i2RKxqx+RP+139e2hF57HPxdgLB/JiEI+FsEnKLk2NBv8Smhhllm3AFlYbriMGQ3v8nVipUqFCIaGfW3yyC/wN1KN
 NPyAPygG
 5/1D7OC/mMKQnrM57XfqjxwDpxufUs4dG+jYxIHK/f6lLxFf+dpkKCDqJY8nKlY9cy9rWfWWHhGSv3MNdjj8qsc32C/MwarmETPRIhYTpxJpPNhyKhycJ8I7mgxCWD8V/vjvjfbves7S88MJ6Kdt10jh9H21SLEcqFQh2wb+e3ilv6NVecT7dU2jaa/4xxKMyiMviFc/1ybF4wsM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 22 Aug 2026 23:12:35 +0200
J=C3=A9r=C3=A9my Jean <jeremy.jean@oss.cyber.gouv.fr> wrote:

> Oops, I did not know that, sorry.
> Do you want me to resend once more, or that's okay?

No need. It's in patchwork and I'll manually add Bradley's R-B tag and
start testing it.

-- Steve

