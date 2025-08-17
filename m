Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45D73CA0EDC
	for <linux-mm@archiver.kernel.org>; Sun, 17 Aug 2025 17:04:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E2558E0040; Sun, 17 Aug 2025 13:04:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 893028E0035; Sun, 17 Aug 2025 13:04:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CFBB8E0040; Sun, 17 Aug 2025 13:04:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6CE2D8E0035
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 13:04:47 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E50D55A43F
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 17:04:46 +0000 (UTC)
X-FDA: 83786873772.18.E8AF778
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3D47040008
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 17:04:45 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XMy7gPQw;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755450285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7EoVNwhkLSb8056vofmP/Nncw9DXysnHXa2Iq0AEUKE=;
	b=Dmncl6PmjDt8PgaU3tb0C0pduLQvoE/Quo36kgtEkv4jpx2jlHGpe/DTdIjSzB0nyjqpnF
	eKXNoyET3iHsaaSw/lr03D5Sc9ksa5E2nQLL59Ui4TqPMYOg2paBdqRo5/uSIISr3sA9z9
	tjnLgBq3qXKz0gGe8F6bB9yUIMer87M=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XMy7gPQw;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755450285; a=rsa-sha256;
	cv=none;
	b=8ULydPAyC9/jzSqSG6EjynK1xYwcl7JUFLCGJDPDlbSsIpyanp/mLdIjwbKUG4hLK2E5bL
	Nhlf4k6/9MqF51C2qTJp3l+6CGCPXiRF9Y+H2VvJ1shfttGaebPdCsD/S1UKt64OXTXGzv
	eTWOff1Ea8r2A/FYDVayehy+Xcftm9w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C490F417CA;
	Sun, 17 Aug 2025 17:04:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 840C1C4CEEB;
	Sun, 17 Aug 2025 17:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755450283;
	bh=KTWQtwe8r6oIJ7x+q3kv/WoFv4VvQPP2AkriCOou1Xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XMy7gPQwKc2CeZF7hxhYl7SdA4uPUsXfFIcw3Rp+eshqqCZYUzB24bpJmWSdPn++D
	 UwGTIgFWu2uRQfrWH8wkj323iIoKE7WZIp/7n/5f1EDwEFa4yO0518Ru9oxImP29Tk
	 f+nCiCRJOMhwo9/+GKq2AKGuOkxHIRMoxkDl9TK/mNHdQgEp61D3kmAFdkQUQNLdf8
	 /JEWDxc+bbQ8VxWv80PgEhpP+QBZ2+kDvf6RLhz/1CFYH5Kc+PO6Q0KK9UN4Yc0aO1
	 2MmIbmvMHcuLAsJuLdVVdI5T/AZGcT32JoCEJ/QkIBXiB/wQpBeKrD5bV9nbEZ5WWB
	 AGeYAgleigYEg==
From: SeongJae Park <sj@kernel.org>
To: Enze Li <lienze@kylinos.cn>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com
Subject: Re: [PATCH v2] mm/damon/Kconfig: make DAMON_STAT_ENABLED_DEFAULT depend on DAMON_STAT
Date: Sun, 17 Aug 2025 10:04:41 -0700
Message-Id: <20250817170441.9817-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <bjoel05s.fsf@kylinos.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: x1ukjzomew1z1wiw9bguc6ogimrxhosq
X-Rspam-User: 
X-Rspamd-Queue-Id: 3D47040008
X-Rspamd-Server: rspam01
X-HE-Tag: 1755450285-910583
X-HE-Meta: U2FsdGVkX18/aWlioKmaOPSA1/VGlKHSYzn+kNqVxvxRSkx4debd/uhP+TBcopoqI++99tQKZR0OlwRilb3bXrEQnfP+isgHYoM9Rc3lKafoCwFsQ+meKEoChUjGUUg0EM2xrE08q597NbE5kY0q6ON8d/csJIoN92hul/vHEtT5FwZnxFMVT+opa0RgX0wtf3NfJYK0HVfO0BKI+cVCWJ5nUXRmeNaF9RJgz7Dahmu7mDlYTgV+g5n0MKPqAj3WVb6/fHzcJjsEg07NjgNgo5puFtCZ8iddIZOMLcFfCoCZbS1paWzEXv19ufnAl6EkWeH2HBPXPbjs8ho6wQUwixWPRfv1Do1paA2+xJwdOvaXkG0AJtHarlBMUZOIi3SE97v5XTeyJCrdr7nKw26N8vtRvxkqb0KXY5BmIQLJWgCiYlLhaz8e8d1hGb7WY1Weqnzf+Kccl/WuasTD9n2lZxpJg5JUzReGutl9dJzK3jakLsSg6tuEFsNznoxeP4aIBSG4mCWbwCjiEoS/twi2ASdb6100vgqzKnCSBRMc9iBav37iELLy4c30rFEXtnwivFKUH1AZetZuthiMGXeAfmrd3miGWKM7H1iZHUtqIsu0Zp8WnOGcXg+e+Mat4gtmuYWSDTOdYTo2XFmXuiH9Ak3gZO5AJoKcLAd0A9oYqBVyMnJAkQfYedj0qoA8RB0CneN5/DzwqKZxQD3Zlpn+EDt1iUuSh48cHG+LTw0h/gOxJJkD14LecEoNPny0dZP9NL5taI7UOFivtC0oGCqrEbPlZCiwkyt6Os2pbQjLWjCtiVvdT/DZfjefobo0Pu2kSY+P3RuX2In1BDQ7Tqdg9BjPC4SEFuR8XmJrI+zCVAVMCYM1x+flZI9dm8htIqwOOGw6WZFiIzd7XW4GozUD3uw6unaALxqQfWQciYKYtATZqI4Q+/yTI6xAaqu9vJY4uf7zyLkswucv5wZOlok
 ANuB0NNO
 t95IeU6j4N6MZlhV4DAAqdW9qxQdp017vpTsPsibLSyXgfhyH994xnU/XaFWVPnpU6N8UXeEtFTzWPjuQiALv6jLsgDYjw8aBO+ELz1cH8Xcv73lYwe4xvE1xO3BagijTHQpLwD51k+ASwE+g6kFyayPTVl2HEcPVpw94RRvglEDhUGYYD6R1KcydP/M6ibEjWsLjuEb8sBl3xfuRTZG/ypKK+1M5B2mMlW5j/dM+bjw4OzLTImA/uDGnY02LMrQQOUHi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000001, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 17 Aug 2025 18:20:31 +0800 Enze Li <lienze@kylinos.cn> wrote:

> Hi SJ,
> 
> On Fri, Aug 15 2025 at 09:59:03 AM -0700, SeongJae Park wrote:
> 
> > On Fri, 15 Aug 2025 17:21:10 +0800 Enze Li <lienze@kylinos.cn> wrote:
> >
> >> The DAMON_STAT_ENABLED_DEFAULT option is strongly tied to DAMON_STAT
> >> option -- enabling it alone is meaningless.  This patch makes
> >> DAMON_STAT_ENABLED_DEFAULT depend on DAMON_STAT, ensuring functional
> >
> > s/depend/depends/ ?
> 
> I'm not well-versed in grammar, but using 'depends on' here feels a bit
> weird to me.  After consulting grammar references, it seems to me that
> I've found the answer.
> 
> In *Collins COBUILD English Grammar 4th* (Section 3.210, titled
> transitive verbs with an infinitive without _to_), it says:
> 
> > A few verbs are followed by an object and an infinitive without to,
> > not an -ing participle or a to-infinitive.  They are let, make, and
> > have in the sense of cause to happen or experience.
> 
> It's somewhat like what we often call 'make the machine *work*'.  This
> is my understanding.  If I misunderstood or missed something, please let
> me know, I would be happy to submit v3 of the patch to fix the typo.

My English is really poor, so I believe you're right.  Thank you for correcting
me! :)


Thanks,
SJ

[...]

