Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 428A3606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 23:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=fH5pBpFR
Received: by kanga.kvack.org (Postfix)
	id C2AD66B00EF; Fri, 30 Oct 2026 19:43:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDBB56B05B1; Fri, 30 Oct 2026 19:43:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF1636B05B4; Fri, 30 Oct 2026 19:43:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7FF636B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 19:43:07 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DE8251608A9
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 23:43:06 +0000 (UTC)
X-FDA: 85380920772.17.192174C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2D748100003
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 23:43:05 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fH5pBpFR;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793403785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vTsgS75SWh6JODmQ/6GBwZ7Q/loys1DrlZ7GGQLEh8k=;
	b=GR6b1AQ8QtkNvMX8PUkr0HGhcHjLJBW8S1XDQzzmaDrss0VaEn/EyAcNGjj/cz0hiZT+bO
	bLbCaaFu6fxRppMZFuPbRteTZ+wuCIBYrVg3wblSQjhpGQyARepvng7TdDuH5qKS+ET7Vu
	xIktj0XeE4lKU/3lT5lCpa33rhvLG1o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793403785;
	b=dmaCykPPr5R71QStAXVtBBbuPR9xCoz+vFTZ2+6rEvBmMzrK2Q+TP3UjSl4DylaV/wqjFI
	agS4f4fodQBsOg1RpWCk2a0rJIlmWSF/JqhoEU29m+uqC5/o2BUTVzYJhWWX3t44O8U3Sb
	HYyBwqozYeHEcck3J0S3YuvXBY4SOh4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fH5pBpFR;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 446D9601F8;
	Fri, 30 Oct 2026 23:43:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AFB41F000C1;
	Fri, 30 Oct 2026 23:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793403784;
	bh=vTsgS75SWh6JODmQ/6GBwZ7Q/loys1DrlZ7GGQLEh8k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=fH5pBpFR9FV15LjnYPsaAdIoki8/201ThpJ6320tgeW+DueHIqcMhV621GaCmirKg
	 tgpsNTuELBVfcDeZisphTB9hGKlh+PDNQKvyoQKsBxh/yN6UuXNy6K5obUFGBpR6Vo
	 2cfr1QgTiDc2lqLlFyBLxNqZbdO58TpYo6AJiJ1c=
Date: Fri, 30 Oct 2026 16:43:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com, david@kernel.org,
 ziy@nvidia.com, rakie.kim@sk.com, ying.huang@linux.alibaba.com,
 harry@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/mempolicy: recompute automatic interleave weights
 on memory hotplug
Message-Id: <20261030164303.02c5cce0521c3d6fd4ddf015@linux-foundation.org>
In-Reply-To: <CAN+CAwN+OPMPpVdBA+XtQvFpDy+EOY2TAiusxMjYR+r0F+MPhw@mail.gmail.com>
References: <20261030161234.1505367-1-gourry@gourry.net>
	<CAN+CAwN+OPMPpVdBA+XtQvFpDy+EOY2TAiusxMjYR+r0F+MPhw@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2D748100003
X-Stat-Signature: tbp9beswwqugnddpk74tqszozh6w33sk
X-Rspam-User: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793403785-593357
X-HE-Meta: U2FsdGVkX1+MoBTL1AoMk7F9v4liXRAFVqvRfDK/BWlGbEfvuEkmZKEs7fy5r0rjEN4nhvmH7DyAV1E/cuyGrji49V25Ge/pmC1sOUXsyTECqPptIgvphNgChBXtLAss4EsmFRaz3QuPtrENeOQA2D+ZnA5RETebDioPkSF2GqImK0wjtLzG98UknMdjD2jahRBGi7Nx2JWLsA9ash72YULtt/AbHg27Vjhe+zKS4e3uNki0OMCpT2FNSpfWkYxpXfMNCVvCNecVC7V+7WZCQdu3oBhcPU7Q6v2clDYRgm9rKMiUi+tPmElcWkRhQQ1Hwxc4l8vLiM+h3OC2ef2QoBAC1sb6PXyn0YkRnc23ONE1jy6ZdiMb59gV9WpG0n1EHgjxdyGzTr5pGl6mr1mFiGnPbkne+moEtASIPYBGzp/pggM0xIEiPw7ivJQ690YQfsiiZyg/jtpKJYxsLKokuey5GCgkNnO+nzCLWpaGgoZ6pILJOWw0+OYfuiEzZD+BcDhd5po7VpvDIvvxPKtF6rv+Atekyi/sKRvM+oN69P15DUvi2HSJMC9n7XfFwABMQuJHCibgWD8kPGD9taqaBdevDVKDPdLljB2L5E6bvCA6DrmfxwTlBXOLDYCnFVlfKQCerioTLzsoSdMHtx7D0mgZN57YFtsZgWhA0FtPnD9VUd69MFCqh5xxojL9Kn33RdVvvE+cJ59ahHyJFaHIRtCcX4jYu8ke8YR+/gZ79XOILl//QMav8lQqjXiw/gNlSM/0ZxUsQnqBYutvRGDGEjS29Bp0x8OGI4J2JYR0B9yawk7lUM+0DPdy3sKBt8EHtlypK29B4tJS/QVOUw9LMPLrS3Ra2X/qC1OpJOsFzVC637W5MDmn6seO4RsE8ui3hBH5LGqrUeRhlD+RmFY52Nf6SZCz3/SuNNzT+X2kzYKjmbHrvgpfWvYh+RAdovMppU1W6yasYHzF8x70XGq
 e42P1CT1
 WFSBbrhnFIs87M8Cyg0x8UANG6otEbX2mL7LOA/ri5GLNIdUO2YF0vJC43BrCib/jJwy/gPDGhHJ+aDqCcDiC3RINdBaXNSCEws9hqR+J91mvugjm5jMjLbIV4nXErgjbgjylxCwkWs6c/szMSDYSfi05txngZ/xpCTgEB0d1MeB6T0FPyjqOATK57H9kVELuUR4/VdsmVYXI6i8/yJ79mPJqeq923Ut7ODPF5CwnRrKxw0/2TV6YALI132+sgJTIpsWsFDTCPbDo5ed4Sh21bIPoNbyiMbtTGTIF+2NrVq9Dch+OtBEIpp7N7ajn+k5hNE9K4YgqQpvTXAfbBEPKlr4jKLGp1dxwb3o9dUO5vQvFPMEedGw5vsD30snC7qPbgXV81yfC45LyUAgwmh9ELv/3fq0FHMCTmVftuxN/bDbt3luRybRH0zXqtg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 30 Oct 2026 12:35:38 -0400 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> On Fri, Oct 30, 2026 at 12:12 PM Gregory Price (Meta) <gourry@gourry.net> wrote:
> >
> > In auto mode, weighted interleave derives each node's weight from its
> > bandwidth, reduced over the nodes in N_MEMORY. HMAT and CXL report a
> > node's bandwidth once, when the node first gains memory, and nothing
> > else on the hotplug path recomputes the weights.
> >
> > This can result in a major skew in distribution and overload tiers
> > with more data than their respective bandwidth can support, resulting
> > in a performance regression.
> 
> ...
>
> I think you may have dropped my review tag from the previous
> version!!! I believe the only thing that changes is the warn, so
> please feel free to add:
> Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Actually, quite a lot changed, so dropping the v1 tags seems
appropriate.

v1->v2:

 mm/mempolicy.c |   36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-recompute-automatic-interleave-weights-on-memory-hotplug-v2
+++ a/mm/mempolicy.c
@@ -261,7 +261,11 @@ static int wi_state_refresh(void)
 	mutex_lock(&wi_state_lock);
 	old_wi_state = rcu_dereference_protected(wi_state,
 					lockdep_is_held(&wi_state_lock));
-	/* NULL wi_state assumes auto=true */
+	/*
+	 * Hotplug events can arrive before any node reported its bandwidth,
+	 * leaving nothing to compute weights from. NULL wi_state assumes
+	 * auto=true.
+	 */
 	if (!node_bw_table || (old_wi_state && !old_wi_state->mode_auto)) {
 		mutex_unlock(&wi_state_lock);
 		kfree(new_wi_state);
@@ -302,6 +306,28 @@ int mempolicy_set_node_perf(unsigned int
 	return wi_state_refresh();
 }
 
+/*
+ * HMAT and CXL report a node's bandwidth only when it first gains memory, so
+ * recompute the weights whenever N_MEMORY changes.
+ */
+static int wi_state_node_notifier(struct notifier_block *nb,
+				  unsigned long action, void *data)
+{
+	struct node_notify *nn = data;
+	int err;
+
+	if (action != NODE_ADDED_FIRST_MEMORY &&
+	    action != NODE_REMOVED_LAST_MEMORY)
+		return NOTIFY_OK;
+
+	/* The hotplug is done, failing the notification would not undo it */
+	err = wi_state_refresh();
+	if (err)
+		pr_warn_once("failed to recompute weighted interleave weights for node%d: %d\n",
+			     nn->nid, err);
+	return NOTIFY_OK;
+}
+
 /**
  * numa_nearest_node - Find nearest node by state
  * @node: Node id to start the search
@@ -3424,6 +3450,7 @@ void __init numa_policy_init(void)
 	if (do_set_mempolicy(MPOL_INTERLEAVE, 0, &interleave_nodes))
 		pr_err("%s: interleaving failed\n", __func__);
 
+	hotplug_node_notifier(wi_state_node_notifier, DEFAULT_CALLBACK_PRI);
 	check_numabalancing_enable();
 }
 
@@ -3910,15 +3937,8 @@ static int wi_node_notifier(struct notif
 	case NODE_REMOVED_LAST_MEMORY:
 		sysfs_wi_node_delete(nid);
 		break;
-	default:
-		return NOTIFY_OK;
 	}
 
-	/*
-	 * HMAT and CXL report a node's bandwidth only when it first gains
-	 * memory, so recompute the weights whenever N_MEMORY changes.
-	 */
-	wi_state_refresh();
 	return NOTIFY_OK;
 }
 
_


