Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEB09C44501
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 14:19:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B80A56B00AD; Fri, 10 Jul 2026 10:19:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B58056B00B1; Fri, 10 Jul 2026 10:19:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9A9E6B00AD; Fri, 10 Jul 2026 10:19:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 84E506B00AD
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 10:19:09 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1DE2B1A0484
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:19:09 +0000 (UTC)
X-FDA: 84973074018.25.B355927
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7AA6E16000B
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:19:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bd++3JU6;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783693147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dlb3WD7/szOCNyvIUD9XAK0jmIyFraoZyD8UZq/GPXg=;
	b=MKk3z+XqNdbuGH+DJI3TjpNXJT4oRhMA79kULp5MunE5RfbnEfuPgiM7xlF8aZmShT2ZYG
	bQI/bZoOnTj9lUCXuJeWwlBXHemRVGOM2ujfdGYnL7znQy+lhJktrXT+IUevDPEjgfW8aq
	A7rm+CBewiI7ecWHQthyaT3HUYCQ4Vw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bd++3JU6;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783693147;
	b=PLGGKxMegBuZlF9EMZVB5Mf4Co1M8q2fDjU/NeqMduVUDdcjsMuOD/dR/lFHL1BN7bNiCJ
	Rp2kLvyRUVHbJhwCV71TzWIcrqpPkrimbfbvYEliZoRXw+7I5x8WJwZn7slLdtkChTkupa
	AeYhASFRJRirRB6pYcaKs0IGv1ITmoE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 86A1C43BE1;
	Fri, 10 Jul 2026 14:19:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39D251F00A3A;
	Fri, 10 Jul 2026 14:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783693146;
	bh=dlb3WD7/szOCNyvIUD9XAK0jmIyFraoZyD8UZq/GPXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bd++3JU6myGmdIMMne53urwP13UFJCmJ7dBhnvgWv5Fmtz9ryc7S9KMuyqEPbopMO
	 Cf6kscvoweWO7QVGoOPMYEENlT8EpH/UnguxrAs4oAe9RqqQLww4YlFOxnn6O9Imtw
	 G5YBpI9tulEdjpz74VJy1oLMZzscuRFxLyAeyReVl9eeqFcyB3rBxL6fF1W72sFJ3L
	 pQfRHmK/n9/ByfYsUzGSuaMEj2V0jsD9u3Uw1l5nMud/dgZnCp/rMxFpI5qhm9qHfT
	 AQ14cl4meMv4mfxaMftZxRxzqpUulZ+gA+ID7ejErCHPOvWnBoNrh4lJhhzPECEt/Z
	 A0XYgiRNFpTcg==
From: SJ Park <sj@kernel.org>
To: Song Hu <husong@kylinos.cn>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH 2/4] Docs/ABI/damon: fix typos
Date: Fri, 10 Jul 2026 07:18:58 -0700
Message-ID: <20260710141859.24919-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260710044737.561102-3-husong@kylinos.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7AA6E16000B
X-Stat-Signature: 4h85h3o3rr8pgy3xu4c8k9cw6dncme53
X-HE-Tag: 1783693147-360015
X-HE-Meta: U2FsdGVkX18RSYa3LEC4ff5j0JDStWo5tt1XPt/hoRkzhElxFR6r2OJ+XPiP9dKESvE/sUdJ446egbAo6OcHjlZ+zC+3vbCzZ/QzPk6OwAfjpSpezNHnN0hNHGaNK1hYuth7cXWHDMr4eFcTikGhpllrwx0hEg77H4ki3en7C+Xd+DvPjtZZ8YOXK1fEIRmupM4umNEVGqruiIof9Iu2Hl1z9chzuz6G73//vUzbMGhjWq1TcRtAHlv34miBitggxnMAssXvoJZERznsR2kF9MQIZ0NGjY2yf2b0m9wjO4uzBwkO5zTi2Lbi8dBlBewad74v/bmtSIYWB39+RwEF5RvpWS4YemLBHnaCdf6lXfP7rz44AjQ6budeqSRbAYnLnGnrzqcbQYExt42DfbI49p7B/m/17P2XJtvbeL9eAohBt0axdtSsE5HpFF83ZxTj5ulusQHSwFyBEEGtiRyUU6BJwSRswB+RfgyN3dD8MVWqSvT9htZlC9jAs68GCAsd1+xvypDzUVxAUz3I9Slici3VVNdvrS4Uziw4qDneOQ7JapaB3qm2d0ldy8oqOLDhTidLymNxW51EGSO1AR9SyqjugZSGLeO6RqvGSacDGrRzNPO0xkUqmeF3w4tWQoYn491QHu04AqBjqPsDMomu6LTtKx8m4v5kdOmEHboNViadpb8w68PybO+xC0w4Q8RH+yyG8g7nGpft+T/bc9qiQKc1cyQmsvhJBVfk2l2P3QUxatNdpa5MypcCdYEQlvXAbXgcYa057ty/qDvMsb0xFEwAwDsZy/oNe983JiSQRHT18JqenRgQiYMR4GELD+QT46xLgqukWsOwQ8VmAngNnZL92xZJF8JeemRgcULIYZpQtuHM4CKkctzDvRrIaf6/JUBLXB/Up94rIjSKDAUj07L4nafC0EHu3JuKokPQS3B1AFgtqE88VeNPtgKuTFKo2dHltYh33Zpgobhb3yU
 nq13EfDF
 UPfVCanbImAOQ4XWt6QQyHM6y93MEDvUI77buK2h7uzoo8zmvqAy1XpeNl4OdtyPumRvq45mtLgGT0QXe0RwBtbeRk8UjLeaalupqOsNCLI5p7hKYSuaQ5IhjWsemN/BXBE3vcpO3YbN1n/7cq+Ii83tqyBYANG6zwYHDLXzVKJwuC/9bDh3jfjAkd808dt9nEG4n+EXzze5QVALIMV7YV8fuBGUVLJ38wRv/cCiWx/1yTLej/O2yEdUdDSNnobXmVBt9cRvTC74ItN4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Jul 2026 12:47:35 +0800 Song Hu <husong@kylinos.cn> wrote:

> Fix two typos in the DAMON sysfs ABI document:
> 
>   - "WDate:" -> "Date:" on the nr_regions/min entry
>   - "manimum" -> "minimum" in the nr_accesses/min description

Good eyes!

> 
> Signed-off-by: Song Hu <husong@kylinos.cn>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

