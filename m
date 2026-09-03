Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BF7EC61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 16:11:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E723C6B008C; Thu,  3 Sep 2026 12:11:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E499D6B0092; Thu,  3 Sep 2026 12:11:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D604B6B0098; Thu,  3 Sep 2026 12:11:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B04A26B008C
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 12:11:07 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3A5FB1C240D
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 16:11:07 +0000 (UTC)
X-FDA: 85172940174.15.8096563
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6F8FC180011
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 16:11:05 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JxlK65jB;
	spf=pass (imf24.hostedemail.com: domain of patchwork-bot+f2fs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+f2fs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788451865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0GGJyshhlAlKfjOpgr7j97Mh0m1+5qav5ykVgFpFUIA=;
	b=qDIDfn1dhy/EmgapDOkfiwlqn+fTO5KNtiH3u+JBna/vOU/2zmPrEagdjIqzLkapoMriko
	YfEoh3OUWSUcDwfGTJ56/EblvUXF/Hmh1DSGh8n4Jcff9/XdmRWn24GVFcq4VLIl2MZ9wW
	+4kNXrB/h1XkBHIPxsfiX6kyV6Mz0tU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788451865;
	b=uoEGW89WSd33Gr1esm9WFoe0lFdHyAbIvNXncsTCVv+uO3XpCu6i6Wu1pQNFLDqDtmEBen
	7Lpxt1fizSHjO2oB+UhnsKf6zzap6ybrrvzW24D9E2qggQu4ceZLILsbxbOe1+CuzEd/FX
	6BX6wg04hhlCRPRcQ/lkFFJWhdWCoL0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JxlK65jB;
	spf=pass (imf24.hostedemail.com: domain of patchwork-bot+f2fs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+f2fs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E634E6053C;
	Thu,  3 Sep 2026 16:11:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BFA01F000E9;
	Thu,  3 Sep 2026 16:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788451864;
	bh=0GGJyshhlAlKfjOpgr7j97Mh0m1+5qav5ykVgFpFUIA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=JxlK65jBcGgrsk9TAjqXxFnNxMSr2EUzOMWx942qjPBc2ybpTNX4WvsfPUiPxOaFl
	 CvaTGDSQ1oizIiQKMXWYE2OVnwqIcGg5ydGC/+fP1+mqJ1GuK69hXukg6W16b7JT1r
	 w2aaHejOOmNUZBUXMT7w7PrSbcyV2uNkwH9yBFLEDwdRzAceRy7X++SL5zY6FEYsfi
	 FKkGMEhCG0T0FcIFQ+7naHWPwvlEPmk672vo9ZWS+QDqA+Td4EZLGZ+BJGrxKQ67ij
	 TyZdI3BpB9bpqUcAWwS6PSI4Q7NaBwZ/Wa6AfOhrb223ZyOEtRQ2bZ96TF514AV+At
	 BAPEfyocjj+3A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 1986738119CB;
	Thu,  3 Sep 2026 16:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [f2fs-dev] [PATCH RFC 00/14] Remove PG_private by using
 page/folio->private checks instead
From: patchwork-bot+f2fs@kernel.org
Message-Id: 
 <178845180590.3423963.571905514968785918.git-patchwork-notify@kernel.org>
Date: Thu, 03 Sep 2026 16:10:05 +0000
References: <20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com>
In-Reply-To: <20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com>
To: Zi Yan <ziy@nvidia.com>
Cc: david@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 muchun.song@linux.dev, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 baolin.wang@linux.alibaba.com, nico.pache@linux.dev, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 usama.arif@linux.dev, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, hannes@cmpxchg.org, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, kasong@tencent.com, mark.rutland@arm.com,
 irogers@google.com, jack@suse.cz, linux-doc@vger.kernel.org,
 amarkuze@redhat.com, peterz@infradead.org, kexec@lists.infradead.org,
 dave.hansen@linux.intel.com, ruirui.yang@linux.dev, adrian.hunter@intel.com,
 linux-mm@kvack.org, hongbohbli@tencent.com, hpa@zytor.com,
 guochunhai@vivo.com, skhan@linuxfoundation.org, ceph-devel@vger.kernel.org,
 baoquan.he@linux.dev, matthew.brost@intel.com, anna@kernel.org,
 sstabellini@kernel.org, zbestahu@gmail.com, rakie.kim@sk.com,
 minchan@kernel.org, richard@nod.at, x86@kernel.org, ebiggers@kernel.org,
 alexander.shishkin@linux.intel.com, mingo@redhat.com, slava@dubeyko.com,
 weixugc@google.com, yukuai@fygo.io, xen-devel@lists.xenproject.org,
 xiang@kernel.org, magiclinan@didiglobal.com, mhiramat@kernel.org,
 joshua.hahnjy@gmail.com, xiao@kernel.org, byungchul@sk.com,
 james.clark@linaro.org, acme@kernel.org, linux-raid@vger.kernel.org,
 linux-fscrypt@vger.kernel.org, bp@alien8.de, rostedt@goodmis.org,
 linux-mtd@lists.infradead.org, axelrasmussen@google.com,
 jefflexu@linux.alibaba.com, namhyung@kernel.org, jaegeuk@kernel.org,
 yuanchu@google.com, idryomov@gmail.com, osalvador@suse.de, jgross@suse.com,
 pratyush@kernel.org, linux-nfs@vger.kernel.org, tytso@mit.edu,
 oleksandr_tyshchenko@epam.com, song@kernel.org, corbet@lwn.net,
 pasha.tatashin@soleen.com, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-perf-users@vger.kernel.org,
 senozhatsky@chromium.org, tglx@kernel.org, jolsa@kernel.org,
 linux-fsdevel@vger.kernel.org, mathieu.desnoyers@efficios.com,
 linux-trace-kernel@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 trondmy@kernel.org
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6F8FC180011
X-Stat-Signature: s7p6hq8qaquye3zf5sir88uqyezoazfd
X-HE-Tag: 1788451865-952457
X-HE-Meta: U2FsdGVkX18N7c02yIv4e4/NnuupHxTBnpVF1Me+UfsSU0uxrhRzBNQXKpWgKb7MaRxmrn8DCSVi/icQqmaayYnDws5S5U8n/lqLpjXMgRy2EaRktI2T7lDiUweXgibJrgUQtv8wt+pRJCtK3g6tARtbjHxiEoUxZaWhJ3O3NTkTQEfCXIWGjBmu0PLcInUtgMaiGkGpRorDxJ+8z5ndUwWnfvzWk5OR7ebg5Nn5U/AMEl+HkALSlzZoSV5NUk5+CQdKi/aiQxZsG6dVJEz7BKukd4Cmf7xau0oTNi2/XKqCtzUWWIBN/xeeoCkSuiHNU/J5Q+Z0BL1ZLPXOaY/iZGQKLROJvUuqBhJ5MBLomfHL1jFddOft3z5BmV/3oXWihHRFOjYrcGl2rpiMNlfR3qOY8zoarWSF/DXW1aKFgQa2x1q15uUArkDG5FZ6XK3LALfFV+RR/GaasL822QQDAGfi4g3jwIt9NSbYv83OurlncQw3eCuiltYUx+/Ydf3Wms4MY3KxDhDA/F/ahevlqPNiJQxsmrXbyp3WhJyVfdO6ySPkkfF3iEn4BkBvQgKXgoaQOBjJpQvOuOSwD0hPVKbQODx68dZP81wAQwjQdFRW5T0R2Imc2EHidVC631liOVzIKhugr8QVqYOSu7WUS5E5VYtnrhZwRSPrc1Nu4xL7Ze6yymxiW53T1ltj/YJxt1z256mGU5MSrpaVngFXa47h5dHYOJpCd7iGe1dDg9LV9I/yPhMCXpFsxzH+3OYkuZLSDqBDS+dh7XOUvSuUp3XQFqslud3cJbXATUUSUv06Zur47A9FFL48qPVS6MTBQkEQmge1JXGiRTeFKX9jGK2wNzeQcgKVkex0TnaBLXsdko0lJj2Qkj6oBorcsWIgBcZR2W/CoVDKLru9TmUO/UB4bfLelsXjAfAnDFv8n+CZlswy3Xuent03EswX6kYAuwJxvGGV7dSEF1uXp6A
 Wib/uYT2
 g42I+5igB/7qBpFzEx/edIdkXcIxu1UKOvrcWEJS0enFwGG45gQJmaxrzFKmYJY5uUw0eqN5wjqMDJ0i5S9OZUPFhMiQdorQp4SF0g8rUA3bCyemhjOltEU+lDJvXRA7cEIRgxYkN6+H5ejcMA0zZobmCEj8UhBPt0jO6nwtSPZswFmGKtllzKVfFFOMTx4wQwyJOalAOjdcxiXBysLh8sJxE2zLQwBn9tVruhNJwxo8skDJW1wHbf8pmgRTAv+CLN2m55flNf0dV5z4kFmGa/6VWG/GUqbaYm8rX2cMWjLKqV4IwYcoNzGEv8dD9mU5sscC/ElXzQW6FlFn/DeQfxnr9yt0wVHCiIlPupFXLoWUnJlCJNrUvPc1a9pnmBUPD5QbuJJEdW7KNsNRukt9038SyhWfyjreuld5STzHh+mf6hX4M9891VyxrcF7P7zzCWW25kHSGN0bPPTpJlnZA7tr6fZj/Px0ry79j3Z1Qs6VXK/hmjteyb15HUXyica8xBRTq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This patch was applied to jaegeuk/f2fs.git (dev)
by Jaegeuk Kim <jaegeuk@kernel.org>:

On Fri, 31 Jul 2026 22:13:23 -0400 you wrote:
> Hi all,
> 
> This patchset removes PG_private to make space for upcoming PG_folio
> (reserved as __PG_folio) for identifying pages from a folio (more details
> in Note below). Instead of checking PG_private, all code is changed to
> check page/folio->private != NULL instead.
> 
> [...]

Here is the summary with links:
  - [f2fs-dev,RFC,06/14] fs/f2fs: stop using PG_private
    https://git.kernel.org/jaegeuk/f2fs/c/5ad9409a9533

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



