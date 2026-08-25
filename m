Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69620C61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 16:14:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79A056B00B8; Tue, 25 Aug 2026 12:14:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74AEF6B00BC; Tue, 25 Aug 2026 12:14:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 664106B00BD; Tue, 25 Aug 2026 12:14:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E25656B00B8
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:14:56 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 49BA9A0477
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 16:14:56 +0000 (UTC)
X-FDA: 85140290592.12.4ED12A8
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf02.hostedemail.com (Postfix) with ESMTP id 480AB8000A
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 16:14:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Jvg1+h3Q;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.41 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787674494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1YlH5b9PYM7jA11GCLyb7iWudl/SVZb5yXn2BHQRSG4=;
	b=74oNACuL4YXff4h5NpLTRt8ODV+MXGx84MUJa/P/JJY1UIYd/smCxdkp1hVE/CtWfCdBKv
	Vi5oyVfx8fuT70MEEWCfyDHwbBDdKi8+hsquTw/8fAiuHR3MBFkfOm/qcm/VMjLfHcE/ny
	EgKBW+beeR+r3mVFVVEqqGB2/8wLJAc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787674494;
	b=SssLx/1VwpTHdN5wNaWHgMRbeoAPgUpMj1fbpmsVant0sb8qVrYqJohUUvSnv20SQveWbw
	zqo60ZvR22vWqqZaG0qIA+PJi2PRl3J1X08RKDnsYqA6LFLVJV/fYvy4VrINX2dbhxoMWv
	U81QwQf/GBStTilhv89NhGWQaKoDy/I=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Jvg1+h3Q;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.41 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-8fcc43c48f7so55612006d6.2
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:14:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1787674493; x=1788279293; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1YlH5b9PYM7jA11GCLyb7iWudl/SVZb5yXn2BHQRSG4=;
        b=Jvg1+h3QdCy5kR0dkvuC+6QWnTQIOt2tRYA/LQUMcCC8TXEw6q1ZRqNGj24cZo8btf
         uUVwKgXKoRkNiy0s8TheviOVuUwPiWuTRKi5igOhHmkEF9XmMcEq9YgaNnedbh1Pc/T6
         3QSjIRoAjlVGK9q9S7sbCzLg4vdHivL+GeKKOGcPTACMbS1mvxxX8wJCHmZ2n9AY/RSM
         YeFhvg8ft3Cvi+zyrVKH3pSMsMqLF9/hns8m6k4S8sqW+zRwtfLnGZ7SjoJKK4NE4SYX
         CHtQJb5xlHRGxXkQqXZe5gJx9kj7UF57m+kfNyDOE83Bpk93lD+KR8d9CzqC5MpAF7l3
         q3jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787674493; x=1788279293;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1YlH5b9PYM7jA11GCLyb7iWudl/SVZb5yXn2BHQRSG4=;
        b=MlM/2Te80MNWdIneBWlMGXG2I0s2/m4Y0Kf9YRJniCe/sgf0+KpQi1he6XEF/lKhi7
         p7yOlZTmlLWmeH9BR8bc57MiBNiBiFSei3bwmD0K3kTOwUDgBY5qPwxnf/DhNgIeNj3l
         dFhDvNmjzK4Igf0NO0wOdrUjijW0e/obX6HAdmEpGP8uIiFpM786HlS9yCa3KgTqHMNY
         3AVwlMEf9E5a+yhRCkVgTEjrNmCVs98QqagAZ3BnqvGBYsX9pU+TC/3Z18Rj2uICu2FU
         ohZv0YGRZDWT+nuP6p9VkBDo0azP2PdNVs2ZskjOP9BXnkW4gUhlnsgb9joWQ/dtdAwo
         2M8Q==
X-Forwarded-Encrypted: i=1; AHgh+Rqsamc3u6NazVehUu4TOJgojEczfwXMHS/YtVbi8P/ESWsFpzFn5xEREclP1Czftc6V5opNngkiew==@kvack.org
X-Gm-Message-State: AFuF++kWwrF0wSWQXTGvaqvpPVBcYhiBNNh4NcKiC8c3P4+dLbNjYuEd
	hxO5+2PrOIWlSfzzTRh1L+PUoefpca1m+WhqXnwj+4O1Owso4eMgW05to5eWb/scgog=
X-Gm-Gg: AR+sD12LUQZFvjh3EgxF0ByQxF7yKEjGQ/f+mLndtYI54ZraC41e679pbBNhg7nQOjR
	ej8Kt9ANxkjyGqEzZLKDVksAFzDbqsSEXs4znUoO46LZDASwE8XnNGfVoedGg3Uc672hKhzykEI
	yPLsHPuRW/iq4yIhgD1lOZ26U2A3zNeip7N9x5uGskAO5vz/s2sbGI8gvfiiSOmm9cCrwNTiUss
	I0h3hZBecvweqcuELfRl3rh4DVixizz4WjqfhNMtfNVxFWzXb4rMgncvwlSf9x3PHHeilPHsPsk
	tH5GJsE9Tu263ju/KM5Q0eNC4xHVhUfqHuA1ArP5pY7/IuR2/Ma+7ciryc+fdu85U4o9zzEhyJ1
	SBGZeBNmsRxnHO15z4f2Zgly/Z+LAMqOZJrHylQWmXdR37GTjf5KvYTMZd6EQd6ZW1waWP4c446
	r3f/Pc+9JFwvdwwPqxsJIRTulkCGedAmHl534EQkRrlBDSy7dxENhxvQwqNDW83MOua/PgDhIpr
	xyQmEZOjjwCLAPMz6H6buzUN5naTRUf0pT/THO8wAH+ajEAuSiGYP4=
X-Received: by 2002:a05:6214:3114:b0:8de:25f7:98bc with SMTP id 6a1803df08f44-90c8fa2ace7mr324838386d6.22.1787674493270;
        Tue, 25 Aug 2026 09:14:53 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90cc63c68acsm2381676d6.10.2026.08.25.09.14.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 09:14:52 -0700 (PDT)
Date: Tue, 25 Aug 2026 12:14:50 -0400
From: Gregory Price <gourry@gourry.net>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, akpm@linux-foundation.org, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Hongfu Li <lihongfu@kylinos.cn>
Subject: Re: [PATCH] mm/memcontrol: remove unused memcg parameter in
 calculate_high_delay()
Message-ID: <ao2_aYpnxsmux8p2@gourry-fedora-PF4VCD3F>
References: <20260825120153.1405-1-hongfu.li@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260825120153.1405-1-hongfu.li@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 480AB8000A
X-Stat-Signature: rcxzyz4eqkgw85m5m1f4nfx86ew7swg7
X-HE-Tag: 1787674494-347056
X-HE-Meta: U2FsdGVkX19wU9t8+STHRPE09aAmrTSolyq3UbNAJBXyz3g0ssw+wbw+ZeT0Iqq+SE7IclOJSbwNNYLNjUpDBUEq/FneCcHlxEdRPB//uDAabJ036/BAQnTzr/YOYqzfHdywdPr/+64Ejnd85eyr+A2mxYlr0NpYi9j0P92ZRva0gKGmliWXtfWAVlrqb27ah+UFXCcGcMWBjUHPzw67IOD/KosX5TyayslVJ4KCTUbqFDJnkB2f/mDitWGfr6rJwIBTa09xbIHoYNZ8py44V7cOlAHUxlhr5NZgkjTCbrgclIW1ya1hLpLuXYDe38WV4BrP0Eg/do5g+BMwrvUK1Q3F/qPdWqVIG2mWe4mPkWTcJeyNmyBpS47RzU6X0ndYpTVj8AZZFY2SQac+q7hZL2V1Ptf4IS5xwszieeF12fLSkgEy24m23UJH9bCATm43eLgEM50MAJvDOXXMtx0ySqKf/iKW7x878g6XTjG5z8d8oGdL9sKcfI9aPodErNwgTJmRem6vUh21yK3dBxpOgCfkg9IA9YBizFmudWYXUtDM8bUc+7Y735XiB6tnE1zGrAqZL/5IPCPoSbeug4VssjD1cNgZKAmpyYm7eWNwFlQyOLR5Y7wxNWxdiVDUhf8agmnAULwGKlJDpGHFdkzGXj71VRqZCS2yyzBUufB4xcriYiB8Afaj4A2w+cddG6L9I9JpT3NfjM4JKcZbrXxBziRrk7zEzpMLx+2Ia3aDLMJE2Y75/OTAcctakKNhBTGnDJdfD5HgFpIcaFsEBzb2DAYNlQsahz5JcbiJv7lg+KXDtqePJDxgkI63FkP1WGyP84gLbbeJO/cIFaTjrhoVwY9jf313MkaFnKslGETxMpmyj//LYy8OT3TiZRlQ3nzu6bX1WBcj+fH8w1X1hwML1lMSBPdQIJF7stsjkBb3ARRC6vvO+p3GNvjwpnzoF4ar6Z4UnlBx+x5AVkb/kjz
 K4weK+L+
 hs58Nz1ELHcfy474eHlL2JP5XivWbiCXuaSyVG4g1/Ep7Skv3U/5Le09HjJ60J02eBbWta6xrd9vL5K5Jfgk7r6N5D2nMA7k6vLFK96fa3cEAdEBcBhBig/Xmn6d8efmLiC8jMZcb4PWXMv3sHE5vf9pJoehnI8p8Mkb6R2RYxYONbB5VoscIbuBkAoZxyiqeqqHd0LDRwp8I0RB4jQpFTanNHK4+YBi5E5QFFgVArPePJrwPC6wmKQCIC3FO3i520+6FbJnxqRyaTgcBBrlNkTYbTvyoVvUiR7hfhcZ0hRJAf9JVfPrIBbGvfCnr7Td3bjuzlhrRzBAoNLvFkGhfYbRBZG3tz7RgAqqfUnXHwRVGsTuDGmi9xj56PAkUQRWlewxc/jBDaogEDcGCw0yJxmRGqMsD2FveJSfY1+5DFxdkKQiBE/wIPJScaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 08:01:53PM +0800, Hongfu Li wrote:
> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> The memcg argument of calculate_high_delay() is never referenced in
> its function body. The delay calculation only depends on nr_pages
> and max_overage, and both callers have already obtained max_overage
> from the same memcg.
> 
> Drop this unused parameter and update the two call sites inside
> __mem_cgroup_handle_over_high().
> 
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>


