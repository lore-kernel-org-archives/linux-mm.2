Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4BD0EF8FFC
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 16:40:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4FDB6B0005; Wed,  4 Mar 2026 11:40:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFD466B0088; Wed,  4 Mar 2026 11:40:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFCCB6B0089; Wed,  4 Mar 2026 11:40:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B03856B0005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 11:40:28 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 821D61B8563
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 16:40:28 +0000 (UTC)
X-FDA: 84508943736.26.DFF22F4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id F069040003
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 16:40:26 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YhG7OC2U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772642427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G8WHk+/s6x2ED5IJIByyj2eCKJnAYd3CkHhdGqww5Kk=;
	b=VZ08C4b0DXXVujL3Er6xgDUntlxzPA0n8/WHPRKGrouO9V2BVhk3207j97i4mA6GBheoSP
	tAxqmv02wtIg+ic6dZxSjmxXe4KTy4hnpZDrG4OR87cEZNriKE16JjdWLb0McbykFPADac
	EhVEfIjrXOp6OSpvo0Sem3sgYLWL8MA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772642427; a=rsa-sha256;
	cv=none;
	b=OCbGTN+LIkkZLeqe8YWwrhG2Cx/ziic6Uk6hHMlmOBmHU6wJFwprIcKgL6F6l17x5RIbTQ
	DplOW/zlqJ57iZGPk1bj1ehJRPAxdJq3+yD2j1/b009gfroKb+bVGIC6eIC6T0zVsiSigu
	Was9OfSjmTQ2vHESUZKsCuO9ek+FA5E=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YhG7OC2U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 46D0860053;
	Wed,  4 Mar 2026 16:40:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B457C4CEF7;
	Wed,  4 Mar 2026 16:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772642426;
	bh=zjtjHKRlpOdJAFXpFqfNvOxmBTyKuh8J7CIZSN6zpFA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YhG7OC2UUjtKf3MfSWO435HdWtoax6lg7pnL2C1GXR4/F0LxFuwqT4PIsJsBQ0TQM
	 fNzje4N34+/VU5O2dcI/JL//+O+qr+IfKoYmbthoy5CAIWwr57kigb9xGcWKBmZTEn
	 KDCTnBYBUWIDLVOUJJc27wVnuhu3VnHbxM9zReNu8cxnt7aCn3dK811FnsCd0Clzpq
	 wY0gUuaBUWK4e+FWZaqiBvAyR6C9HRTn++NM8JU+IzZNJO24KxeE2rl9Tv209dmFjr
	 UVYfGsWKQGJQYi2YaR/4sNlukvmLj3ji+R2ItJgQmRm4cp876bRBUHVN30OpSIxnSi
	 ytM5NECv+4TiA==
Date: Wed, 4 Mar 2026 16:40:22 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, usamaarif642@gmail.com, kas@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 1/2] mm: thp: avoid calling start_stop_khugepaged() in
 anon_enabled_store()
Message-ID: <ec07d7f0-cad4-4d9b-8e40-d4ded8170340@lucifer.local>
References: <20260304-thp_logs-v1-0-59038218a253@debian.org>
 <20260304-thp_logs-v1-1-59038218a253@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304-thp_logs-v1-1-59038218a253@debian.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F069040003
X-Stat-Signature: fqxpp3qh5bjahtyg8k3cbmgbwirn43wa
X-Rspam-User: 
X-HE-Tag: 1772642426-616682
X-HE-Meta: U2FsdGVkX19A97foJdEA2vyNdq/9Fra/xuFIWbML+6+g6DsWvncZY4+2aHwc0FA4bEF/3PWbFnH1iRORVdFN12Rh024eIkfErj2yU+tQqkGHxOmCylq9tSBaKcg2OXtss43pDbBlQnLAkeImm5qr733jonc35LesIik2h/pS4n7/gs6Ro3qao6gl5OePcbwsI233j7xnN46l78+9Rs2Bt56mLBDHARVL/7Gp6xrJEcqwvYBaoj4WHi4drEMP5ZAIHzyDXh1RjF7wHJfQAmfvV5asQJPYP55LLa2Tnz8bvwF7J+MH0sHnSDDlyxA/BsJ0sII2lgKYgMxXObrUiTWt+3PT/tRevns49np5+8nPVn9oc8MZ3ANpJ4kAeaSKNauzoABFX58L/Iigu2dySdj6SfXgrUGAny27uzOw/SUEIdeSBRa4I65lDpsbT2D1osvffD3ceFqSprDTFS/ZpcFPyZh3WXUbErvcVT/DdRr7VlkDbKbYDsYhb8/0qAtv1xw3BC+8HrxqITWRaGLnzsGvTsTbcnWc0HopjDjJCeOaLokGW08zOGcERhnblcJnmRHKzQaWovV0EFs0a5hItRYZPhEkpObkQQczbZfVyPSqyTIL0dEbyNRLKL5a65VRozMEykgz2B/DQjv51J3PzGpaEA5WQD61P8s75+WsGFD/I+XIXgQE/mNzAQ9ZOtGlthzf7Ugj5UafitKHKUHcf1TLLkMRJAgRlG/Rhtbx2+XcD2GA9r2n2BkP7oDLK53kgbBgn6qv5C0D0kbo20L86qORQWdPBPBBYZWmohGH07OHpeabqwskcQ+q8zkOM/Z+Z2Iic1zoiu9jw6BOKsWBKA+ggrnVW7Vu5ohvDlDDBo2mMY07vFs6pNMSUSyH+E+SXPkTBKfhht7sQyy90uvoHZ1tZjpLw1TMM9iVVUECCi2PhGUYayDxexfRivtjbPa4r6esvjw0at9PW1rSSL4Zh/E
 3GwXVFff
 u3MeGwnctHWJhoMdZgsuFESDPruNPVQkZC1TzC3rXyuoeQNFm7+a6ziem8pbB8GWoZKkyQUgi3Ataoq/f2qrgAHb39+jlgqb3iyrdaR5C7gZ7T4wYlwAzQ8e8LPx5Vhsjeq53egGeojmN3Acw6yqhWGRugVbHh2P5vR7bTTmZk0DdFRpHCirhi8QufDSgeZUN0YNYdT3Zv8mGe+lI6GDk0FmgS8oG/kSGXKM6TEhFA1GAneyb4blXsZ/0kP7kc9VaZut0WM4W2h2zaOUk219+M3PE/Ojzs/3j8ZGVA5wWXaR8TfGqVp5lmsqEZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 04, 2026 at 02:22:33AM -0800, Breno Leitao wrote:
> Writing "never" (or any other value) multiple times to
> /sys/kernel/mm/transparent_hugepage/hugepages-*/enabled calls
> start_stop_khugepaged() each time, even when nothing actually changed.
> This causes set_recommended_min_free_kbytes() to run unconditionally,
> which is unnecessary and floods the printk buffer with "raising
> min_free_kbytes" messages. Example:
>
>   # for i in $(seq 100); do
>   #       echo never > /sys/kernel/mm/transparent_hugepage/enabled
>   # done
>
>   # dmesg | grep "min_free_kbytes is not updated" | wc -l
>   100
>
> Use test_and_set_bit()/test_and_clear_bit() instead of the plain
> variants to detect whether any bit actually flipped, and skip the
> start_stop_khugepaged() call entirely when the configuration is
> unchanged.
>
> With this patch, redoing the same operation becomes a no-op.
>
> Signed-off-by: Breno Leitao <leitao@debian.org>

General concept is sensible, but let's improve this code please.

> ---
>  mm/huge_memory.c | 27 ++++++++++++++-------------
>  1 file changed, 14 insertions(+), 13 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 8e2746ea74adf..9abfb115e9329 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -520,36 +520,37 @@ static ssize_t anon_enabled_store(struct kobject *kobj,
>  				  const char *buf, size_t count)
>  {
>  	int order = to_thpsize(kobj)->order;
> +	bool changed = false;
>  	ssize_t ret = count;
>
>  	if (sysfs_streq(buf, "always")) {
>  		spin_lock(&huge_anon_orders_lock);
> -		clear_bit(order, &huge_anon_orders_inherit);
> -		clear_bit(order, &huge_anon_orders_madvise);
> -		set_bit(order, &huge_anon_orders_always);
> +		changed = test_and_clear_bit(order, &huge_anon_orders_inherit);
> +		changed |= test_and_clear_bit(order, &huge_anon_orders_madvise);
> +		changed |= !test_and_set_bit(order, &huge_anon_orders_always);
>  		spin_unlock(&huge_anon_orders_lock);
>  	} else if (sysfs_streq(buf, "inherit")) {
>  		spin_lock(&huge_anon_orders_lock);
> -		clear_bit(order, &huge_anon_orders_always);
> -		clear_bit(order, &huge_anon_orders_madvise);
> -		set_bit(order, &huge_anon_orders_inherit);
> +		changed = test_and_clear_bit(order, &huge_anon_orders_always);
> +		changed |= test_and_clear_bit(order, &huge_anon_orders_madvise);
> +		changed |= !test_and_set_bit(order, &huge_anon_orders_inherit);
>  		spin_unlock(&huge_anon_orders_lock);
>  	} else if (sysfs_streq(buf, "madvise")) {
>  		spin_lock(&huge_anon_orders_lock);
> -		clear_bit(order, &huge_anon_orders_always);
> -		clear_bit(order, &huge_anon_orders_inherit);
> -		set_bit(order, &huge_anon_orders_madvise);
> +		changed = test_and_clear_bit(order, &huge_anon_orders_always);
> +		changed |= test_and_clear_bit(order, &huge_anon_orders_inherit);
> +		changed |= !test_and_set_bit(order, &huge_anon_orders_madvise);
>  		spin_unlock(&huge_anon_orders_lock);
>  	} else if (sysfs_streq(buf, "never")) {
>  		spin_lock(&huge_anon_orders_lock);
> -		clear_bit(order, &huge_anon_orders_always);
> -		clear_bit(order, &huge_anon_orders_inherit);
> -		clear_bit(order, &huge_anon_orders_madvise);
> +		changed = test_and_clear_bit(order, &huge_anon_orders_always);
> +		changed |= test_and_clear_bit(order, &huge_anon_orders_inherit);
> +		changed |= test_and_clear_bit(order, &huge_anon_orders_madvise);

This is badly implemented already (sigh) so a little tricky as to how to
abstract.

Yes the existing logic duplicated, doesn't mean we have to keep doing so :)

To put money where my mouth is attached a (totally untested, in line with
Kiryl's :P) patch to give a sense of how one might achieve this.

As to this vs. Kiryl's... I mean it might be nice to fix this crap up here to be
honest.

Maybe David can have deciding vote ;)

But see below for a caveat...

>  		spin_unlock(&huge_anon_orders_lock);
>  	} else
>  		ret = -EINVAL;
>
> -	if (ret > 0) {
> +	if (ret > 0 && changed) {
>  		int err;
>
>  		err = start_stop_khugepaged();

There's a caveat here as mentioned in reply to Kiryl - I'm concerned users
might rely on the set recommended min kbytes even when things don't change.

Not sure how likely that is, but it's a user-visible change in how this behaves.

Cheers, Lorenzo

>
> --
> 2.47.3
>

----8<----
From cb2c4c8bf183ef0d10068cfd12c12d19cb17a241 Mon Sep 17 00:00:00 2001
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Date: Wed, 4 Mar 2026 16:37:20 +0000
Subject: [PATCH] idea

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 mm/huge_memory.c | 74 ++++++++++++++++++++++++++++++------------------
 1 file changed, 46 insertions(+), 28 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 0df1f4a17430..97dabbeb9112 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -515,46 +515,64 @@ static ssize_t anon_enabled_show(struct kobject *kobj,
 	return sysfs_emit(buf, "%s\n", output);
 }

+enum huge_mode {
+	HUGE_ALWAYS,
+	HUGE_INHERIT,
+	HUGE_MADVISE,
+	HUGE_NUM_MODES,
+	HUGE_NEVER,
+};
+
+static bool change_anon_orders(int order, enum huge_mode mode)
+{
+	static unsigned long *orders[] = {
+		&huge_anon_orders_always,
+		&huge_anon_orders_inherit,
+		&huge_anon_orders_madvise,
+	};
+	bool changed = false;
+	int i;
+
+	spin_lock(&huge_anon_orders_lock);
+	for (i = 0; i < HUGE_NUM_MODES; i++) {
+		if (i == mode)
+			changed |= !test_and_set_bit(order, orders[mode]);
+		else
+			changed |= test_and_clear_bit(order, orders[mode]);
+	}
+	spin_unlock(&huge_anon_orders_lock);
+
+	return changed;
+}
+
 static ssize_t anon_enabled_store(struct kobject *kobj,
 				 struct kobj_attribute *attr,
 				 const char *buf, size_t count)
 {
 	int order = to_thpsize(kobj)->order;
 	ssize_t ret = count;
+	bool changed;
+
+	if (sysfs_streq(buf, "always"))
+		changed = change_anon_orders(order, HUGE_ALWAYS);
+	else if (sysfs_streq(buf, "inherit"))
+		changed = change_anon_orders(order, HUGE_INHERIT);
+	else if (sysfs_streq(buf, "madvise"))
+		changed = change_anon_orders(order, HUGE_MADVISE);
+	else if (sysfs_streq(buf, "never"))
+		changed = change_anon_orders(order, HUGE_NEVER);
+	else
+		return -EINVAL;

-	if (sysfs_streq(buf, "always")) {
-		spin_lock(&huge_anon_orders_lock);
-		clear_bit(order, &huge_anon_orders_inherit);
-		clear_bit(order, &huge_anon_orders_madvise);
-		set_bit(order, &huge_anon_orders_always);
-		spin_unlock(&huge_anon_orders_lock);
-	} else if (sysfs_streq(buf, "inherit")) {
-		spin_lock(&huge_anon_orders_lock);
-		clear_bit(order, &huge_anon_orders_always);
-		clear_bit(order, &huge_anon_orders_madvise);
-		set_bit(order, &huge_anon_orders_inherit);
-		spin_unlock(&huge_anon_orders_lock);
-	} else if (sysfs_streq(buf, "madvise")) {
-		spin_lock(&huge_anon_orders_lock);
-		clear_bit(order, &huge_anon_orders_always);
-		clear_bit(order, &huge_anon_orders_inherit);
-		set_bit(order, &huge_anon_orders_madvise);
-		spin_unlock(&huge_anon_orders_lock);
-	} else if (sysfs_streq(buf, "never")) {
-		spin_lock(&huge_anon_orders_lock);
-		clear_bit(order, &huge_anon_orders_always);
-		clear_bit(order, &huge_anon_orders_inherit);
-		clear_bit(order, &huge_anon_orders_madvise);
-		spin_unlock(&huge_anon_orders_lock);
-	} else
-		ret = -EINVAL;
-
-	if (ret > 0) {
+	if (changed) {
 		int err;

 		err = start_stop_khugepaged();
 		if (err)
 			ret = err;
+	} else {
+		/* Users expect this even if unchanged. TODO: Put in header... */
+		//set_recommended_min_free_kbytes();
 	}
 	return ret;
 }
--
2.53.0

