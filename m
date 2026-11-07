Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38AF9606D82A
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 15:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=lZbFR2qj
Received: by kanga.kvack.org (Postfix)
	id 4D03D6B05B4; Sat,  7 Nov 2026 10:37:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A94D6B05B5; Sat,  7 Nov 2026 10:37:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E56A6B05B6; Sat,  7 Nov 2026 10:37:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 177AF6B05B4
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 10:37:24 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AA1EBA0372
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 15:37:23 +0000 (UTC)
X-FDA: 85408727166.05.2D2DDCC
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
	by imf15.hostedemail.com (Postfix) with ESMTP id DC101A0003
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 15:37:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=lZbFR2qj;
	spf=pass (imf15.hostedemail.com: domain of 3sEXvagUKCFcEIDH75DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--ptosi.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=3sEXvagUKCFcEIDH75DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--ptosi.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794065842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BA87cHxXtTWR3BYiMzRslM1IopR1GCSiZApOjRzAgt8=;
	b=GRDHqjLJ+QmS/YP3k6dOlFjMShGJqCi2kPzW2NMSuAmxG/I6iJ0WEFsmEnlh0lRPeZGucu
	G20BRUxAB04JzDd8XdsdcJi89oUVjCCshVh7Lyjz3V3hmRc6uyboYch1/fDmqp8U9sWApd
	WDIQ3WhKRXXVrDA5yqL8LtY7DbVRkK4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794065842;
	b=XxrBWbdZgr6flBW3BClP1WBtQm+FcqzOaG5gkt9yY436fS1mayWqE8Lbf9l29JmjHTxPf3
	p0yQ+xHXQGbgtwi2zF1O3Ddl4hFRrQRcUJlb9tTG2HSvH281wLbIEet6RXFfCZtD3fkFCj
	57tUSfrsfbqxHREugzPPgFjR7z8GiWY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=lZbFR2qj;
	spf=pass (imf15.hostedemail.com: domain of 3sEXvagUKCFcEIDH75DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--ptosi.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=3sEXvagUKCFcEIDH75DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--ptosi.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c41f85ee4a3so155543966b.1
        for <linux-mm@kvack.org>; Sat, 07 Nov 2026 07:37:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794065840; x=1794670640; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=BA87cHxXtTWR3BYiMzRslM1IopR1GCSiZApOjRzAgt8=;
        b=lZbFR2qjMFrmsHA5FoSh6rbc2meiUEIiQ43zKO/bE/fAt2F6JIzKyTketk+Zqrph25
         d8NEX91CjM1AV3RIn1flIs7KMgp+yiUAtHdyAoP3iOYmCHtgfUvSWlAlt4ISdkQAciK6
         67oLq5ejx2D41izjTiqG4saKm7xCN6DZg3+WPtRvs2l2p4oAOIXB4zcUSdzMgDTJg5nL
         PhFHBFaQJY5gm/RLHQ6BXQVZk5WIoAmKGmaEik3Let3BRENPwR0C53sfOi1M3SMza98l
         3HPyna/WE/gaVAmy1Mq1mtazaz+xf+VCbty9psDgrEDHOOodDMXxdkiNGdx7r3ytBo9u
         5G3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794065840; x=1794670640;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BA87cHxXtTWR3BYiMzRslM1IopR1GCSiZApOjRzAgt8=;
        b=GBcfv7OuhHHDYt8//BsNqUB/meQ0WOAcTV8L+lHTNFLKb/iJEz6DXr1PWgioABgqp2
         QOPoTfC+WDhcJtoodPq+214QrnFWzBwCSW2cf7pxz1mugcHXeb8f2s6OZxkaYoCCBLXZ
         YeIA78LHOAw9rJpx7FTYzK8cnStp4Sz4ng+/nSUcbumg2LBFbuZVugu/0E+ieqmtDzFz
         6NbITOi6OdPwB9GjETqq441/v35Bz5dVhAmKThbRm0eEDNn+O0EauGkv/9hzRwi/UMHN
         A7pQ2zQr2E2jE3c+CYk8ufyYMEGQkzTGca8t1oJ/rm0y22xxKsUSiQboqhZREI0D+wZk
         n4hg==
X-Forwarded-Encrypted: i=1; AKwUvBx5Qps/dGubvc6pR7maZTWiO2wHY9GjX697qdhbcIKDmh/x9/hJt93C2iJsYfMfSxG3qeVxuwRHcQ==@kvack.org
X-Gm-Message-State: APuU4Z+ds6e357EaX9UkiVjSrKetd0SRPb3iP06mOX32QWxBW/eKdeIU
	NFYmqV/VbKP+ljmnlGAR4il8tGCt8saRm3akA6IO6NvX20CKQEIxr27/cnJZsNosVmC11pZBosb
	kDw==
X-Received: from ejblu34.prod.google.com ([2002:a17:906:fae2:b0:c4d:356c:195b])
 (user=ptosi job=prod-delivery.src-stubby-dispatcher) by 2002:a17:906:9fd0:b0:c40:80eb:c54e
 with SMTP id a640c23a62f3a-c4d3449c0c7mr421982466b.4.1794065840288; Sat, 07
 Nov 2026 07:37:20 -0800 (PST)
Date: Sat, 07 Nov 2026 16:36:15 +0100
In-Reply-To: <20261107-mte-kasan-split-v1-0-d84ea5f30f94@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261107-mte-kasan-split-v1-0-d84ea5f30f94@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20261107-mte-kasan-split-v1-9-d84ea5f30f94@google.com>
Subject: [PATCH 09/24] kasan: rework hw_{force=>flush}_async_tag_fault()
From: "=?utf-8?q?Pierre-Cl=C3=A9ment_Tosi?=" <ptosi@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Alexander Potapenko <glider@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	"=?utf-8?q?Pierre-Cl=C3=A9ment_Tosi?=" <ptosi@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: am3pxsfsutitjsyubbi1q6hfccwafr4s
X-Rspamd-Queue-Id: DC101A0003
X-Rspam-User: 
X-HE-Tag: 1794065841-712501
X-HE-Meta: U2FsdGVkX186wTi2Ozc0OUpfK1So7MbJONk1IqVPqAkhIrw5KK1HAJkNdhxRo4NZmzfD6nlGjq/I7RKKWEUmZt7TSCgclv3bDoQFtXN7cQfA//ekd51ZPDd+0Yil7WmvLPSRMaRwojhb9XwWjDVRGVyXIX/3mX+tg0jpLmWpzl2zzueceVpZGMKkVruFtlx7xZ9PdkBrqK48gVnVXctp1YNMzNDrY/hgDx10F5Awr0PicVN/DtLwvFD7P+fWO6+OvRkq+thNH7zo+9AfV4JLKzLQZinp4l14aN0Kyxrpw8AHzAXJGdqeWuycVIYb7jvH6bYfDiYnzGgOxkwMtY/Af5KaqQVwvcWxbfeVJHuNadA9VPRldUoSeV7MV3Xwgk1/1AIo7dHPabTKi5z8257/yWGYXYvGYMnKkk7kXldmONie298GC2F1925vdTdLPH/fANtkMBnNmJVwNyB88yuTBlPv45tiDvPYb7yax07Yh2/WmuVJvlcCdeOEyxQ89fWlSTP+jZwSkwyUrdO8zs+qgCy71DW0rCSp3DRg058K1X/nh6Qilo4bwiD1fZJomXKJuLJNCvvP33S631TD88VSfGDxrIIULYEsvSd7RxTgQTlBcEPnP0hf3JmPuyV26nYxI7cIuBaI7ti4cEBHXE9Ykjb71dwCJ86464F/tExZICwzZPaHaZ8ZYO4zCAhwv/NQFaPVodPys9gqq5NZy5VMUQn++ukzD6yKkiSL3fLiy9zmdw4Wl9FcDnrEkR0cosLW2G9v0uhCBZsJ12/YrGunQH9//tNprTNVI1vqjWObcQfsKSo1Ctj0I3OC4RWfpbjRXzWP2RcjwhqJiEMakMAxmPoRwCu7YGeNGBJ69v2nLciycbppddQ5gBP0BXky+NSCIZ/q79tphsicLAgaw5REoi4ve005EMZxIKdIuXqtmHk0midrAqWedxzRloVtBpSFtnEvZdthR6XrjAAeE4J
 ROofe+Mx
 yShOi7JUIMWgVBfLhWCtJOF82Wc7qcVRsfFXwLzJmBhhapZUqbWxeXOAAPQubpTD5W95tCnBsD661uY4ix0nYli6oI3D/4l3ggyB3YphdPile4WUWN4CmkNraYJ0DYuQ7Z7eCVsiFAjOlmVENEilCx4XR0XouP44S5KlR/RNEpX9lSUo5j8EKssPqCcRorRhgQt7P9QqWB0eP+/pKbQFQWT8SM//+Mz3XilHI6A4EyMf4zxM56FFW5hraOFgbp6kEptAdQbgXW5DXH85TAg3jezRsrhxmn/8DHD5u8iLoeOr8HkhJgw5zvZ5U29dRmFd50Iae1NUpiTMu3QB/JSW9kt/Tk5cvuQfpntmCh+yqGq4tzcjZxnxlRTiyYc6rfoLmyA3lKaye9Dtpjo1HhvlgDDh/fSjwBxMDs7Lma4B/b6OQKzKG8bU49t42LNtGF2VzDnzM+bnesBwqBeQky2+gbGxafPlu5ws4LpUNYg5vOch0LlPWG5pmPURtc8Tg/RRLI4UQFGCTW6G8TDH9hDYNV5swe7IBguNDq/fcB9K8Tbf6hHFyXkTmbnTVCdww79r8fxm8Zx88cjgXXeBV/ZcwrWAgsxrl7RLL/zd+ve5laUYZy37CaHASWHif0hhUN9AtZts+1+Ag0iNEV8B3f0OS138htJJdVKM+utrlCX/gDOoRXE9W660wIzaKaToWSV/fiNwTv24kX6CoO9n4embNGPi4rxgrPAjG7kRyaFvLzjZTkB/kcQ02xL8sMqLJglyPh9vmxw4dZD5NC913TYYgSt+qfMh8o+LH8zcVLNNQuKeBJxX21fyKBeXxXl+ghGmwxCvh/BfKcSXot5Lw6VzBJiS6qUpqUwxFDv7Tl3AfesjloQqtznV0pYjb479WQI1HNqff
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Separate common arch-agnostic KASAN policy (fault reporting) from arch
HW details (fault flushing) by reworking the function's signature.

Update its only definition (in arm64) accordingly.

This resolves #include challenges arising from the circular dependency:

  mte_check_tfsr_exit() =3D=3D> kasan_report_async()
    kasan_report_async() =3D=3D> <linux/kasan.h>
      <linux/kasan.h> =3D=3D> hw_force_async_tag_fault()
        hw_force_async_tag_fault() =3D=3D> arch_force_async_tag_fault()
          arch_force_async_tag_fault() =3D=3D> mte_check_tfsr_exit()

Cc: Alexander Potapenko <glider@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: kasan-dev@googlegroups.com
Cc: linux-mm@kvack.org
Signed-off-by: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
---
 arch/arm64/include/asm/memory.h | 2 +-
 mm/kasan/hw_tags.c              | 3 ++-
 mm/kasan/kasan.h                | 2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memor=
y.h
index a2b7a33966ff..8e751b56d20c 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -316,7 +316,7 @@ static inline const void *__tag_set(const void *addr, u=
8 tag)
 #define arch_enable_tag_checks_write_only()	mte_enable_kernel_store_only()
 #define arch_suppress_tag_checks_start()	mte_enable_tco()
 #define arch_suppress_tag_checks_stop()		mte_disable_tco()
-#define arch_force_async_tag_fault()		mte_check_tfsr_exit()
+#define arch_flush_async_tag_fault()		mte_get_reset_tfsr()
 #define arch_get_random_tag()			mte_get_random_tag()
 #define arch_get_mem_tag(addr)			mte_get_mem_tag(addr)
 #define arch_set_mem_tag_range(addr, size, tag, init)	\
diff --git a/mm/kasan/hw_tags.c b/mm/kasan/hw_tags.c
index a848eb2f9910..c4772eebb80d 100644
--- a/mm/kasan/hw_tags.c
+++ b/mm/kasan/hw_tags.c
@@ -428,7 +428,8 @@ EXPORT_SYMBOL_IF_KUNIT(kasan_enable_hw_tags);
=20
 VISIBLE_IF_KUNIT void kasan_force_async_fault(void)
 {
-	hw_force_async_tag_fault();
+	if (hw_flush_async_tag_fault())
+		kasan_report_async();
 }
 EXPORT_SYMBOL_IF_KUNIT(kasan_force_async_fault);
=20
diff --git a/mm/kasan/kasan.h b/mm/kasan/kasan.h
index fc9169a54766..be5dcf6b052c 100644
--- a/mm/kasan/kasan.h
+++ b/mm/kasan/kasan.h
@@ -431,7 +431,7 @@ static inline const void *arch_kasan_set_tag(const void=
 *addr, u8 tag)
 #define hw_enable_tag_checks_asymm()		arch_enable_tag_checks_asymm()
 #define hw_suppress_tag_checks_start()		arch_suppress_tag_checks_start()
 #define hw_suppress_tag_checks_stop()		arch_suppress_tag_checks_stop()
-#define hw_force_async_tag_fault()		arch_force_async_tag_fault()
+#define hw_flush_async_tag_fault()		arch_flush_async_tag_fault()
 #define hw_enable_tag_checks_write_only()	arch_enable_tag_checks_write_onl=
y()
 #define hw_get_random_tag()			arch_get_random_tag()
 #define hw_get_mem_tag(addr)			arch_get_mem_tag(addr)

--=20
2.56.0.455.g6c5a503b38-goog


