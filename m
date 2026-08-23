Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3DE4C5DF8C
	for <linux-mm@archiver.kernel.org>; Sun, 23 Aug 2026 19:41:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDB8D6B009F; Sun, 23 Aug 2026 15:41:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB1B36B00A0; Sun, 23 Aug 2026 15:41:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEFC06B00A1; Sun, 23 Aug 2026 15:41:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 742416B009F
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 15:41:19 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 08BC8C0384
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 19:41:19 +0000 (UTC)
X-FDA: 85133553078.04.D030413
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by imf13.hostedemail.com (Postfix) with ESMTP id 40B1D20002
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 19:41:17 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sKxptV7G;
	spf=pass (imf13.hostedemail.com: domain of 320yLagYKCPw02mlerksskpi.gsqpmry1-qqozego.svk@flex--wyihan.bounces.google.com designates 209.85.210.197 as permitted sender) smtp.mailfrom=320yLagYKCPw02mlerksskpi.gsqpmry1-qqozego.svk@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787514077;
	b=YFEc+IK85Sya482Mf1qXY/sFgzJh0xH1FDKK3mkHOM1JY9ruOWTw+hAL3mdHQzcK/wSmFK
	q3CkdqcZo5WO+34fpa1GefKPLXDTuLg8QBZ5USAw/wl5nMEnd7sULW1r215Hsw5smQphRe
	6G0suFVEPGjedszLheBMkUieAeMANes=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sKxptV7G;
	spf=pass (imf13.hostedemail.com: domain of 320yLagYKCPw02mlerksskpi.gsqpmry1-qqozego.svk@flex--wyihan.bounces.google.com designates 209.85.210.197 as permitted sender) smtp.mailfrom=320yLagYKCPw02mlerksskpi.gsqpmry1-qqozego.svk@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787514077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Iy2xP8SK9yJbNhS8FwmPsx22x8G5GrN0of+eDDc1n/E=;
	b=NA9LnFpWmEqXHyFWuOSmZ6OUz5we6UVlqAhYVoX2Rpl8Ajpx1mHnvdFw7AFz0TQVl2Bgql
	m3YZiesSliCgLqqfOLAF3nIwLl4cgEGQn53RgnlHDQJCXY4LmH1940NsMhFY3LLSOQ49vg
	hKucD0pAgPzbxjgI0ofYIdBb0JD2FTA=
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-848568a6f62so2884247b3a.0
        for <linux-mm@kvack.org>; Sun, 23 Aug 2026 12:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787514076; x=1788118876; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Iy2xP8SK9yJbNhS8FwmPsx22x8G5GrN0of+eDDc1n/E=;
        b=sKxptV7GYv/L7fdUP+94xgYLmUXY3AKuG8jbiH1N06wgMZOz17rpky/whLX6GmgNCN
         s5ByKMlL+ymBLUXsA98HfRHRxpcxXaO4V2l3yCqPv0bvMJdM3MAPsPLiR46gU1TQKrqY
         q1bpAjVMXp3BRiJFfxka14o/puHJfXzi4+I8cDlZG02DbYH95xvLb7gzoa9AzR9SWlGg
         TtCuHcKtPe5tFrT7CYrWlT/dygYeCFQQ4XTBKTsdy5ZnsgTLXvzuY2ziwbFUB0yfCvUV
         gxmVRzR8kmZE5J2FTsXg40C+6jAFX1MaoopDi4wjJHEIzjg3E3FpRMtax5vaWlehbi5r
         Th1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787514076; x=1788118876;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Iy2xP8SK9yJbNhS8FwmPsx22x8G5GrN0of+eDDc1n/E=;
        b=b+op405Hbw9aYKpCpSS0PhlFQhe1HSZgX1BwJSGwcpkgHLoD7o6YWpj6MJOg8GYuaE
         qFb9ZsXl+dH0+UwKmp9CI6lbLVIFZCZdR7jIGWGRlWalTuUqWDNZuYho6qUn9fT1i63y
         nJGhNW00O0dN4KA+RICvWEbTr+dKk5/oj/TkMMK/xbXIVe/pgAGYqCMZxIqUuejfz7wX
         gANv9c7Q0FFFDEDo4e31BpClMkrFJs8qK09IPr8L0zSriC3O03Kd0avJ4a3QJAc4xVHm
         UtymITWG3zwMmSGyX/tpfhlm702BrnI5DaFZ1nRHViD3Be2Jpz4ZLgKC0tl5JpcKZsJ7
         vhlw==
X-Forwarded-Encrypted: i=1; AHgh+RpnZySb0mMYukGKjEOHKiVdpnqGRCkQ4sG3UP9wvkfQzCxOvNYWFgnjbKhLxkbBr4lIKKpZXsUjrw==@kvack.org
X-Gm-Message-State: AFuF++nC93+AHyiHfXHEIkxh7E3MygH6pAUxJv6A62jrqmfqRilYEWWT
	FxuX5pzcVfJ8a84kAEyh8wmtCDo5ULzwHCS6M3SQVD9IAbeI+AlzPjVBpJX0DSjpZUnWy41KhP+
	f/LqnAg==
X-Received: from pfve12.prod.google.com ([2002:a05:6a00:1a8c:b0:84f:d0db:d487])
 (user=wyihan job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2998:b0:848:2ab3:ddeb
 with SMTP id d2e1a72fcca58-851f9fc70e9mr36741015b3a.14.1787514075918; Sun, 23
 Aug 2026 12:41:15 -0700 (PDT)
Date: Sun, 23 Aug 2026 19:40:56 +0000
In-Reply-To: <20260823-memory-failure-mf-delayed-fix-v5-0-d97a5703e45a@google.com>
Mime-Version: 1.0
References: <20260823-memory-failure-mf-delayed-fix-v5-0-d97a5703e45a@google.com>
X-Developer-Key: i=wyihan@google.com; a=ed25519; pk=cRi0fKzS5BMxlHyHY2pJv3w/1zcgfYKr6EYGYppdMYc=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787514072; l=1748;
 i=wyihan@google.com; s=20260319; h=from:subject:message-id;
 bh=7+x/sWXp759BrhYESvsKCOdad1Y/iKVS+soYyV1CIy4=; b=t6KDI83BTgefmAewaihHmX8c+a3Z2iVi2HmHLIEX8ewkBOpraGu5znzx83qmcqz9NkbqAA93K
 XHaFoPVbaLMCwjlTnZrExtl4UfWAk0GR1XY30NzM8pr0DtLo35T2mE1
X-Mailer: b4 0.14.3
Message-ID: <20260823-memory-failure-mf-delayed-fix-v5-3-d97a5703e45a@google.com>
Subject: [PATCH v5 3/5] mm: shmem: Update shmem handler to the MF_DELAYED definition
From: Lisa Wang <wyihan@google.com>
To: Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Andi Kleen <andi@firstfloor.org>, 
	Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, Rik van Riel <riel@redhat.com>, 
	Yu Zhang <yu.c.zhang@linux.intel.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>
Cc: rientjes@google.com, seanjc@google.com, ackerleytng@google.com, 
	vannapurve@google.com, michael.roth@amd.com, jiaqiyan@google.com, 
	tabba@google.com, dave.hansen@linux.intel.com, Lisa Wang <wyihan@google.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 40B1D20002
X-Stat-Signature: p1pn4opdgj4fj1iuzqcbybjsnmy9f9as
X-HE-Tag: 1787514077-347022
X-HE-Meta: U2FsdGVkX19JtcX8+319dTKEuhEGAlDVpUON+Db1l3CGib7KE5fScOkzslmR/kOA3GEuw+W4lJYNzsUwd7mBpECmBJyAarpOh9BbJ/qc/fdTyNIpg/1boiTrLiv2s9lex6JY4oRmrPIOWpaG+LUSWYt+kRXKdlkY/g6VV/kOqqBylFZ/MLKNAlnNdQpf/+p+/Kb+73ZbrLa8IPM+5Q3rbcCU25dVE5HdFr6wXXyjT6JIRhZs3OX94ii6QfhY7zVUeBmG0RiSrkTmQiN5Zwxn7EzmjN0CI20zQSv/FwWkBgMsaMIpOJhtBA8QEGb3OY8X3Nwya+V3Lqb2H6xcVj9gAcFvZejLgFhtJEsZr29T1OPAyC3fSEyCt7SW79c/9CRJkcgjiOljW7Iy1WVTX1iG41fiH46Qsn1I16aeYb5SvMSz/fKpbUTLWL4LwtmmkEu9EmSI9kqq5CDLdRq4sVVUiZLG9ylWS+j/4x3haVq/BDjHQMqDKs29xXAy80u9hClwoYw67uIXpJ3O9dlsqavU033sTk+L/Rfcy/OY55PKUlm6IOx/vuVXIA0aQV/Zr9fEBLZCDBZGbwqRXWc/RLg/0mfYR0Snqj4bFNnEUCWtqbqha79hWkrisHfNu4HtsyjTuY1SGSTV3Dwt89C9L4S8JEJrtFV1z1MYQxdc+1F+pf65OrlLgqjs74dJkOdNuqp96sRf2AdNbJfPTdwW1rN3h24nqilf0mQLMq8RquHzo/TKNW+hMmcRZXCKFPlSGwvi5bcgWG+GBsPjjBXq1gOXAR6zdjCsZvUHhfaC9K7HHqRIyqNLmd82rdOA0AdQmUcCgasuDbAx90VybszhKmqkMCJBgpOaNRavYMo+EBMebd/ISeTOI69BIKAc7kZ0LInrNK4l72QAj8naKuSwgFRUUEf1lcGXxw9P/YCi6MGOG8XxUDLUdyjW172PtUVOpjIf2ZJ3wkHDnk7zh/edNRS
 MLSf7HSq
 onpDECccAKrvctNckQC8jwVS6Eqxaa5t8imKyI/9jO1sgktZgKBD7CniJRDIut04CtVFAogXHVKMRwJkfZ6sIdA+TbBl09yNT5jo25yCnYzozkwZpaGCgXVtF6G2i6zKdjn8E5uzZudC9OY3KIUhNu3zjmB+lWLjLK/tYC60RmI+V2Yd5BYYC7XtxiVDKe1faZ3EXVgyDuV4CY03Hh9NJRmbJM6DiDcn/B2VGVsCDlcBwGkaeSaBPsBFoUsTNorHpYq0lDia5AflhlA0LKxENXcFMlsXu3pLW8Nd4pDDxYTY4yOrXDqK9JTBRtE3/5S1XkMwcH52KBMW/RgvQYitO3o2n2dwMKlIDfwsGGMsyTjG6+6StPxWoL9bCTtiCZsCA8W+D8qzlua60ZbSXkGEsAgGjS+38qscM6NFeVXAAMb6MEGojYLt34yaIUHOxSHnMMJz/n7V+OppDQKWt6KZIMnSrb8n2wIwe7SztnAZSxBsJQFbuZKwTK7s/lo9Cr+Jy1xmAwhL4weVP/o9LxaHTWal4z4GlkVxvPe7WkeHU6GANKjmkZi5DheNKZrFBZvEPGKxOKdB1w/bTS81ZYaQ8cAsGubaaulJhPUvQuK/qXO7Qq34YiSmUGN3iciU7qoCEkfUt3ybur/TPu4dzecJVlBt0/d9B3rT05IrppUFUFqCcdSmO31BLig1kp/bjcKuBf55zSSMPGl3zEmmVmK7QCW2ibw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To align with the definition of MF_DELAYED, update
shmem_error_remove_folio() to return MF_DELAYED.

shmem handles memory failures but defers the actual file truncation. The
function's return value should therefore be MF_DELAYED to accurately
reflect the state.

Currently, this logical error does not cause a bug, because:

- For shmem folios, folio->private is not set.
- As a result, filemap_release_folio() is a no-op and returns true.
- This, in turn, causes truncate_error_folio() to incorrectly return
  MF_RECOVERED.
- The caller then treats MF_RECOVERED as a success condition, masking the
  issue.

The previous patch relays MF_DELAYED to the caller of
truncate_error_folio() before any logging, so returning MF_DELAYED from
shmem_error_remove_folio() will retain the original behavior of not
adding any logs.

The return value of truncate_error_folio() is consumed in action_result(),
which treats MF_DELAYED the same way as MF_RECOVERED, hence action_result()
also returns the same thing after this change.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Lisa Wang <wyihan@google.com>
---
 mm/shmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 774f4b18ff5c..d6f94786e709 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -5136,7 +5136,7 @@ static void __init shmem_destroy_inodecache(void)
 static int shmem_error_remove_folio(struct address_space *mapping,
 				   struct folio *folio)
 {
-	return 0;
+	return MF_DELAYED;
 }
 
 static const struct address_space_operations shmem_aops = {

-- 
2.55.0.766.g2966f0265a-goog


