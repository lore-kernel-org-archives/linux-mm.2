Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7127606A329
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 02:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YOB5Wdz9
Received: by kanga.kvack.org (Postfix)
	id 988F56B00EF; Mon, 16 Nov 2026 21:42:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 960296B05B0; Mon, 16 Nov 2026 21:42:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8773A6B05B2; Mon, 16 Nov 2026 21:42:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4BC8F6B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 21:42:42 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8FAE3A7BC0
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:42:41 +0000 (UTC)
X-FDA: 85443062922.17.9CCF104
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 00AF51C0004
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:42:39 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YOB5Wdz9;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794883360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CV/8yQe2iMIuyGyk1G/Q/QXie74bXsaHYJKwVGXVxoc=;
	b=VlMMS8FPY0ix+g+T1pgaoKzHY5p/MAwI19GC/t1mWCNU+bF4rfP6pyn2ZShExaHdl+HyLq
	yKudTTSSIKUT+7YQqK2w69HJvvdsacEOxDCqXwnLlOJBazbMDGt/+gYlgx4N/wyPmm1ZXT
	PcBMs2BTk/QIWiE2WL5M5LXZPyTuEcE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794883360;
	b=PMRfWOGs0AqJdan0BYHZNI8hIYebzBKSjZ12oJpwlknxYp8d7mMSaZ+2K+krwzbKOhhQTC
	X+W/aBDJ1/Z/eOcd5ckYScOOtj3kMHgRa9tAO/fdblM0H4qVGu5PtYNxPL9XWi/ZiS1cKe
	K7+yb9IK2gv+zaMwdS2Ws0FB2qfjXVI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YOB5Wdz9;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6B3CA627BE;
	Tue, 17 Nov 2026 02:42:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C115E1F000C6;
	Tue, 17 Nov 2026 02:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794883359;
	bh=CV/8yQe2iMIuyGyk1G/Q/QXie74bXsaHYJKwVGXVxoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YOB5Wdz9H1jgHIcXmTMbNCpa7DHT2t6ztkS13qf8w1JHlrggkQ6+xUM+9g9p2akeC
	 ZbS3uzAb+yDQUc73pxgdy+3cQ5rBZfKaP834GbR5Jwzhut7BzfiNCH4EGJGLf+9Ndv
	 o4MMnFDITh3Wbv7U0qifeQW6hWs9ovjP02qGOImwwiT0kkSmpLmVkQQnHVKBeC0a/v
	 fZnrGVBTA37azhKsPz/f1uS852hkZGmgaG4hPjg11i+OdX/mFMJ+7GEj51Y2T+32xP
	 Lpk5iEI+s/hSJdBu4TwwRPzn2EYvWi8tDDUvtEdewEOfI9UqLd/sRWzjKwRYD8IxBJ
	 +XWZLPk7CqOTw==
From: SJ Park <sj@kernel.org>
To: Mattathias Pinchover via B4 Relay <devnull+mattathias.pinchover.uber.com@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Mattathias Pinchover <mattathias.pinchover@uber.com>
Subject: Re: [PATCH 0/6] mm/damon: add sz_ops_filter_passed_last DAMOS stat
Date: Mon, 16 Nov 2026 18:42:31 -0800
Message-ID: <20261117024231.113721-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261116-damon-sz-ops-b4-v1-0-1cffe7227e6d@uber.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mccuhk9zw5iti7i76i61yg5pfhqybk3h
X-Rspam-User: 
X-Rspamd-Queue-Id: 00AF51C0004
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794883359-221500
X-HE-Meta: U2FsdGVkX1/7uIVyjE93RPR+nswXCDI5ATyTMhR590wVP2lNz4muLnX206LVlhNk4dnzG2u75FeX1GYTS7X5oUsujK0eRIdLHQjl5DmGaClEYbxVFopo6zuXj+OF7OUo+8HQPaqIniy4UHPV4GUSOLNPhI+pVtckS4pzH1j6ifObxLwCIIbu1Gm1+nlKA9icWZRnKvh4Qz/1Fpd78QHK9D0t+zdp8d8oczhl9HsQ6DtOv0+G9pk4N/tPDAAETmRQJ8Uk4OxjWbT98tc5AcOkaK2zH3i+67Xr1W9Y60bxWSEF1qPcD9XIawMhdqMzky6trAxx/hjHbqVfbLLfs7O8nYANqtI8S2DUk0qYKC/d4hfIVG2a16vl5MdhUeCHMAeUc248+rwZQo28czMscY5GwGdwUrQpKOCcrP/Ob0SMVHVyXVjI90wnHUVxTO0nFsD1xzNZS1C1V4dXHr2Tu4bdUW+1l788d8yCoFAARuKQkJ4oarluVvyXFyYogY2cdTihkirpNiNucEayn+4ZGQCshNyK81jjvJ0bV/WYKUDKjKKIHAaddU+CINkKkwQlIaMY27NcE2KAUqs5NgZaAVMM93jMoYZuLiXfADWAXnLUkNRAq8DFchPe7ZHSELnydedUjC5yChfqareMMNJdsO+wWv0z+0AGmPpJVGtmw6ZHb8fLN6BsDct20EPQzqMIohi/XUqjhpGHfK0paTGHIanhbonY29PKd+MgXK8+kcSP0XPN9Alzum6C41wK4sJxLlBE38qILEFMzZ5cBF7i91d8tp5ERColrVSPoZC+emDouIO7wMB/9CZQpGuH6fWxFDiOFhaRNtqw9qAUtdy+QHuBvLjkhyB+6CrposUM08pJ9eU5px8M/klIfHOEvxKuaDe+W8gu6Tss71a9TgBX3EaBSXJVGNb9QAYKWAZ0VG6WYb/l8XOkvsFIClcw65Vp03hNwceeACjTUHt/SFGEcDJ
 53WkIGzP
 IZOSa/nJ93LG0DMOUZP+R1qZakEJYVT5wm81aTz/KKMygNo0XTwpoop1VN2lNvU/aYhSWO11szGZ5pSHGo8aoxt2Dl8Yx5K9Fr/qOv9xO/00IMMcxew5Vg8GDEBwHmt5DBC+pWdiLepVXOR8I5o+yB0AbXWX3IjgkR0OGoidG8jMz6tO9mjkck1pX327CrRm3S16pKgrWTEdzArbJYDF/g85Jp1YPqK1Xi4BOjbV+GCRrN0It4V0HKcjZy5lgt9lsBW/nWSO8FOtKjDG/F96dXV1xKYEj+H0IbDQRZZh80Whxlu4360crHbnRE0cPzK2d0Jt16vMoR9JIwBsSyBQpHehiD2Ti7AyzMpR42+42zGksTWkCI1U5u3wUeEZCZfcUcstEm6+yeg+/ln0g6Aj1lED+xryVfQu8OzPG4RBw46sb5XA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello Mattathias,

On Mon, 16 Nov 2026 19:10:03 +0000 Mattathias Pinchover via B4 Relay <devnull+mattathias.pinchover.uber.com@kernel.org> wrote:

> DAMOS stat sz_ops_filter_passed shows the total bytes that passed
> operations layer-handled DAMOS filters, accumulated from the beginning
> of the scheme's execution.  Users who want the amount for only the
> latest apply interval, e.g., the size of a workload's anonymous memory
> that is cold as of now, have to keep the previous value in user space
> and compute the difference.  To know how many apply intervals a
> difference covers, they have to rely on nr_snapshots.  But nr_snapshots
> is increased once per target per apply interval, so the computation is
> complicated for contexts having multiple targets.
> 
> This series introduces a new DAMOS stat, sz_ops_filter_passed_last.  It
> shows the amount of sz_ops_filter_passed increase in the last apply
> interval of the scheme.  It is updated at the end of each apply
> interval, and kept unchanged until the next apply interval is
> completed.  Like the other DAMOS stats, it is exposed under the stats/
> directory of the scheme in the DAMON sysfs interface, and refreshed
> together with the other stats when refresh_ms expires or
> update_schemes_stats is written.

Thank you for this series!

> 
> Patches sequence
> ================
> 
> Patch 1 introduces the stat to the DAMON core.  Patch 2 exposes it via
> the DAMON sysfs interface.  Patch 3 adds a kunit test.  Patches 4-6
> update the design, usage, and ABI documents, respectively.

I left a few comments.  Maybe patch 3 needs a change that might deserve
respinning.  Could you please address all the comments?

> 
> Tests
> =====
[...]
> Tool use
> ========
> 
> Claude (Anthropic) assisted with the code, kunit test, documents, and
> changelogs of this series, as noted by the Assisted-by: tags.  I
> reviewed all of it and ran the tests listed above.

Knowing what tests are already passed and what tool is used is helpful for
reviewing.  Thank you for sharing those, Mattathias.  FWIW, Assisted-by: tag is
no more required [1].  I don't mind having it, though.

[1] 1e035297ffda ("docs: remove Assisted-by references")



Thanks,
SJ

[...]

