Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9EF6C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 22:55:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9BAC6B00A6; Tue, 30 Jun 2026 18:55:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4C276B00A8; Tue, 30 Jun 2026 18:55:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 962506B00A9; Tue, 30 Jun 2026 18:55:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6F4B26B00A6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 18:55:22 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DAED2166B3D
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 22:55:21 +0000 (UTC)
X-FDA: 84938086842.07.ADEB2CE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id EF3AB16000C
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 22:55:19 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="G/aWsL+g";
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782860120;
	b=i1AbweSxGGt56UsJw3A7qyuE0HVh4EnqFBzWesIEW6aL5zECdagzdYCBuY0fOp82RpLYPF
	mWazyHnVqrLEDnd3pQR6VmRzhQ48ItWNohHKgD3xLYCaM19qX8iIOzBSGs9/0RZE48/dZx
	rYOU7mYk8IzlNVh4M0aukMX7ymQsbHw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782860120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uf4NCErCtbDw+Q8rHtEwdiycQJlKnF842/UAloF/2Fc=;
	b=6fy+5xQR2iVnwtoMRVGMmjX030/ADwHzRpI6u446jm+LdgR3XALfDh2RMyLvstbeHm5V8z
	lRHxYZAlqJkBmIy5uUwS/FHtpf1fXHUYlTKxEE5pq1MZCNGjLUBdH/SHq9F5Up2T7k1rNs
	nsBVrLAmpdhKpZJtFvwgmLpkJXsQvEM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="G/aWsL+g";
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E616B43B1C;
	Tue, 30 Jun 2026 22:55:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 835181F000E9;
	Tue, 30 Jun 2026 22:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782860118;
	bh=uf4NCErCtbDw+Q8rHtEwdiycQJlKnF842/UAloF/2Fc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=G/aWsL+gZx6ItIsGSSmT+5RPKoGmHvOITQxmaCiERCn4DhyhbNap1PAb3oH9MfqMm
	 Bh7wQOO2wDhDS6DyOyc0QD29/68fLKdeBWoBoAUBhJOeSefRHL+Ajk5VDX6LXHq1l6
	 1CSNbVtJfGaTt8Ps/WLqahzU1QRkavjL90LkbSu8=
Date: Tue, 30 Jun 2026 15:55:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 rppt@kernel.org, vbabka@kernel.org, mgorman@techsingularity.net,
 hannes@cmpxchg.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/vmstat: fold stranded per-cpu node stats when a
 node comes online
Message-Id: <20260630155517.38a99de9f32d20abcbf9440b@linux-foundation.org>
In-Reply-To: <akQtx7zhP7pxNCiy@gourry-fedora-PF4VCD3F>
References: <20260627202243.758289-1-gourry@gourry.net>
	<20260627161007.81e4533ce561c2951a69f927@linux-foundation.org>
	<akQtx7zhP7pxNCiy@gourry-fedora-PF4VCD3F>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: gqom8mc5tdfd385urj9y747x19y3rake
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EF3AB16000C
X-HE-Tag: 1782860119-824061
X-HE-Meta: U2FsdGVkX1+uRARnyCao0SRdvB9A4kPVbbZ/L9HNORavqv4r1WEbFy6l9lZOhqxp0xNSi8plVHxvo5R8D7v2BAA8R1+Rlj27qIQClypkvylaBCkLoYySVqnGeD9wwxFIQ8o5G1dpca+UWEVVK5LiRZQkmsf7xZsJQ3WVE7Jji3OSeXOI1kMKYsmvlhX+Psu3z1bIrEngE5dtjsp5jjjUcmzEV8ciFUZDoYH1By83n11UC5bzVCfrx1M2BnwH8ima+aQ4I2EKCWq8HkRcB0YwFIixRhTf7K9z4cB4+Y3KCulU82WPk9SjhtoGzi2MXlm2a0uZyRbczxFMokTU+54xkKCUH1oullRkQYV7MmHCvwmiLVaQa67+CKyvD+7dYD/jLNrivNku3SAPtB3aHn9dnTgmlJBi7sZnx6VpXZ2fTwHBI0NaUX+aQ9kjO018WCIN8FFUPoPRZbch01sfQpqP0+ycD6+eOQeCf6TSJif96v0RITxf/UC3nETEeeVe7lzKUWYqmHrjYhXUnItYYuaFGkk4x36Yn8K2K9ZxlLsDkTfVdHkG/vuOxQLypOLxEUO33vrwOKXlQdDupbiFKUYQNQvPr/HJaDnjWAkNvFDRWJIydlfQHjV6Tx18CYhP/wN/iK9keaX60DLTtW0oGWqN5I7l+2N4bTONWYQC0BzSw3WuMCz+EQoOnkO+G/bRUd5g+VY+XAV5EHSJMoPREITBRiDO0lvBD8W8FnsbSJ3+mAT6PWh60J2MIKkKmQrnUkVoG9GnM5yRzEOYp1hLug+MJTwAONyPxJkakn/NUQOliMMiG8sIXs+Fqvot3dgPvUt3JmGHe5e72pBOr6/SNIqvhuMF2KzSr2FjkZsBAUYskYx61q3kD2LUberRARxbnFW4d5xV5mcZ6a7K0zsHTeeSSTYbhH25V8UoufYKQoEKPFExtJNkRR7UPKziPg7S8DZ81wMKnbuVO26f2UJwgS6
 +gNv+xmx
 iG57pEyVi52Qzghd1TSeIul4bBMw1o4/JN03IuYHrdQQfJWP4KsyO2cO+xGBeEAsgRnZcJSfeQ/W5Fzeef1PpVBc/bvKW+grjdr9jAgB3Qr7p9paM7s64ZCKsj4B7/YVuc06MdaVrnUZ+x5uZzEdVLa/IWHsfyaZyIGiTOxdXxLAnIcSG5Wf1rFJkbtdNeokZXo4dPZJdGl3btWokSW7KS+gewU+RON7QcKw5/yUTlmfFRMeG6MW4K6+JZbpYKCEg+zVtQfRiNZ1lzijIeLr8JDzxgS14uqRwBEbzAIpNBEX/Q/sX7TbKRsBxE/HDxGGMklI+NvbJivBNiw7WElRAmRupyECClVKuvf3hhXxZoqg/bct+wnQ79d5/cGpVLVR9jgP7jPVRO82nBbgTDweS9LiDORpVSSKLQBcFztr+ApjrsMeZngCARtYhn0q04ycVj5sTYjXObIQ0TZpmGdaD4ylGD9l/e4uN4AeE6DLaVp11UK+FdPe2MA6hGTadkx2gXrYrNT96r0bySnnpMVLvlrr2/glG3VN8wnnGazK/0H4OBa2Vb8WDYEdrJSnPILxwXRsE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 30 Jun 2026 16:57:43 -0400 Gregory Price <gourry@gourry.net> wrote:

> On Sat, Jun 27, 2026 at 04:10:07PM -0700, Andrew Morton wrote:
> > On Sat, 27 Jun 2026 16:22:43 -0400 Gregory Price <gourry@gourry.net> wrote:
> > 
> > > +		struct per_cpu_nodestat *p = per_cpu_ptr(pgdat->per_cpu_nodestats, cpu);
> > >  
> > > -		p = per_cpu_ptr(pgdat->per_cpu_nodestats, cpu);
> > > +		for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
> > 
> > and that's a lot of items.
> > 
> > I guess the overall loop count won't be large enough to cause issues,
> > but it's large!
> > 
> > Perhaps there's some simple test we can do on the per_cpu_nodestat to
> > avoid the inner loop?  Perhaps might need to add a field for this?
> >
> 
> I took a look, but that would involve adding another per-cpu field and
> then making sure all the races on that field are respected as well.
> 
> Not sure it's worth it for such an extremely rare event.
> 
> I can try to get clever on the folding logic if you'd like, let me know.
> 
> > btw, "for(int i..." is allowed nowadays.  It'll make this code nicer, IMO.
> > 
> 
> Otherwise i can send you a respin for this.

Is OK, we could make this change in a million other places.

> > And... Sashiko seems to have found a pre-existing issue:
> > 	https://sashiko.dev/#/patchset/20260627202243.758289-1-gourry@gourry.net
> > 
> 
> Incoming patch for this shortly.  Pretty trivial.

Cool, what was the Subject?


I'll queue this patch in mm-hotfixes for some testing while we await
further review (please).


From: Gregory Price <gourry@gourry.net>
Subject: mm/vmstat: fold stranded per-cpu node stats when a node comes online
Date: Sat, 27 Jun 2026 16:22:43 -0400

A per-node vmstat counter is pgdat->vm_stat[] plus per-cpu deltas.  A
balanced counter can sit split as global=+N / per-cpu=-N.

The folds reconciling the split only walk online nodes, so when
try_offline_node() marks a node offline the per-cpu deltas are stranded.

A subsequent online resets the per-cpu area but not pgdat->vm_stat[],
orphaning the +N permanently.  All NR_VM_NODE_STAT_ITEMS are affected.

The existing code zeroes the per-cpu counters and causes a permanent skew.
Fold the stranded deltas instead, before the node rejoins the online set.
The node is not online yet and the hotplug lock is held, so the remote
access to per-cpu values is safe.

Discovered when node compaction hung for a nearly empty node, as the math
to determine throttling broke.  Reproduced by repeated memory
hotplug/unplug cycles on a node under pressure: NR_ISOLATED_ANON ratchets
up and never returns to zero.

Link: https://lore.kernel.org/20260627202243.758289-1-gourry@gourry.net
Fixes: 75ef71840539 ("mm, vmstat: add infrastructure for per-node vmstats")
Signed-off-by: Gregory Price <gourry@gourry.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/mm/mm_init.c~mm-vmstat-fold-stranded-per-cpu-node-stats-when-a-node-comes-online
+++ a/mm/mm_init.c
@@ -1540,7 +1540,7 @@ void __ref free_area_init_core_hotplug(s
 {
 	int nid = pgdat->node_id;
 	enum zone_type z;
-	int cpu;
+	int cpu, i;
 
 	pgdat_init_internals(pgdat);
 
@@ -1558,10 +1558,17 @@ void __ref free_area_init_core_hotplug(s
 	pgdat->node_start_pfn = 0;
 	pgdat->node_present_pages = 0;
 
-	for_each_online_cpu(cpu) {
-		struct per_cpu_nodestat *p;
+	/*
+	 * Hot-unplug can leave per-cpu vmstat deltas unfolded (folders skip
+	 * offline nodes) - reconcile this at online. Foreign access to counters
+	 * is safe: the node is not online yet and we hold the hotplug lock.
+	 */
+	for_each_possible_cpu(cpu) {
+		struct per_cpu_nodestat *p = per_cpu_ptr(pgdat->per_cpu_nodestats, cpu);
 
-		p = per_cpu_ptr(pgdat->per_cpu_nodestats, cpu);
+		for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
+			if (p->vm_node_stat_diff[i])
+				node_page_state_add(p->vm_node_stat_diff[i], pgdat, i);
 		memset(p, 0, sizeof(*p));
 	}
 
_


