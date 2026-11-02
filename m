Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59652606A324
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 10:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HnVwW7Kf
Received: by kanga.kvack.org (Postfix)
	id CF98A6B00EF; Mon,  2 Nov 2026 05:48:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD1376B05B1; Mon,  2 Nov 2026 05:48:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC09C6B05B3; Mon,  2 Nov 2026 05:48:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9CC6D6B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 05:48:56 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 35F19A0BF9
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:48:56 +0000 (UTC)
X-FDA: 85389856272.25.DA4B521
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 588BE20002
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:48:55 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HnVwW7Kf;
	spf=pass (imf31.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793616534;
	b=TllTcOXwQ0mifWGr2dVAopBl7/9esToo6XvSWANh8SsM7co6P1SpKyFFlIAozHgL5jBEuw
	C4aDngshxR5a3f98N87Bk49Qa3oGrvGi7k1V7JGmgsaxNCv07DZhLy7JZ2PwPLnXOcw+RR
	hesaSyWjKgOwzUUrkKUPDjUnzW+dxqA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HnVwW7Kf;
	spf=pass (imf31.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793616534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=alJW2kk7J5aB3H8ldBLPUkr2OufsLz4Kfedbzm9E5IM=;
	b=4rFqcW6vNt9Sbky8DjRpuOYjn/RtKGMFhqAPo76zv6HPLA63WyLd+2cAQccNRKYqxwFFUJ
	TBku4JaSQphmC5OUxFIQoW+e7yifvhqszbD23ZcOgqGjKQdY3lS8SGrocUQC90zhudtnLB
	NQ375alJtU4eD3bt/ox0eCAtdZzL/Ec=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C8B5D60EFF;
	Mon,  2 Nov 2026 10:48:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F1E11F000C1;
	Mon,  2 Nov 2026 10:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793616532;
	bh=alJW2kk7J5aB3H8ldBLPUkr2OufsLz4Kfedbzm9E5IM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HnVwW7KfLlezC07ryu8Ner2cAHeBoKnJL7ulj8j+mU1h7uHy+gFiCV63ZEG1EPc9s
	 khXUH6U1NUHCBUHctO5hKX4sBt3TTIh2OuJP/74dGmE4yePbEjcbCBR0IRQfBKzedy
	 v6crRHKDQQkhCaugH5dDyzH8Gv0eTEzqJXDigav8Uw5zW4AzDykI2X8rXLhg2PLU2i
	 7PoItFPUHnj2RQJ4cDmv1l/FTbq8972RfaDQKbiuPOLMm+X9PDtDjuse3XIZkQDIr+
	 Zm6GNKAnUCpupVNOz7P6LzoLTszUcbe6cp+u74TO4q5j4Fd0ry2DCbdyoP2i4P131G
	 HyuAPg6BZqBSQ==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.ams.internal (Postfix) with ESMTP id DD3441980052;
	Mon,  2 Nov 2026 05:48:47 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Mon, 02 Nov 2026 05:48:49 -0500
X-ME-Sender: <xms:j2roaqMhAgCx0OGLE_P9jMkZUvwMBd1Ec5Z33JP2vsAxVyiqr42Dzw>
    <xme:j2roas4LjxXed6c1J6z5HERG673pqxDxXcGcySyWVBg5LW-1gBdKDt91maHO8uTpc
    0HLJfzw8ncZ90DJVqJiZMUwwlmWD_d-r4S2vlXvRCDSzam5Sl9yNRy0>
X-ME-Received: <xmr:j2roapxaKIGL4oHym3Cd758Udm9h1xxTkgB04o1jqaqEKqjk5w348jSNB-Q>
X-ME-Proxy-Cause: dmFkZTFLgXFKrzIukKez74KoRN/QpvBIENZy2DEhJaNDY+xWb1oHLkm+A5rb6sIqdUVAvM
    NP1YhmibrDW6qjMc3fGL0cv0cQ3HyO6m7eKRR3wecZ5IXtSdDeH7Gr3GPMu9bswl3L0uYA
    RTj7dV9Z3V0dh5heufvc3oC+mh98SmhqG71Ch67Huvja/ZypVHvq+zVRp8hewzmGpCP206
    2jgyCvliHRUFnvVVZfUINAJLONqp2O1n6mJqsIttl7bI9VKnCD5k88P/T3K7aW84rceBmd
    rFsbw+4VTC/kDTfupT+LTyCERrXhVepG09hrp1ldCF6OfGBjux2QsGQGnx3uLscv5FmsRA
    CmXB5GW1wO+1VsU7asBDw0LA98YH9dtaa0bHDpiuaMqvFrbtplFuChSSoePQRnPfllKaRp
    U/Ok9QkfMnkXhvtLdqBcKlJRdC1Tdbn4ZVbId8mNJojrMK54TVdIdNrM3neElYnAgefWFz
    m6eWaetsYXjaTjrXRrDhP6cGUFFDjG9OfFD79fLeu4tYr4NVVbz+fbswHx6ZJrxrc8Y/UR
    CjB8bQc1YOzZNY0oARstdgocn2mwqQ7Gz1eB2fSMDcjb0OQyJQekog98sKkB0dyAqPqccX
    qSlZw4y3PH9Wec4drvUi6pauddDZ4+Op/n/PArqAu8qdlfIiJAGhQcPoQKfA
X-ME-Proxy: <xmx:j2roakTNQoFuVKR-SeDCJMEMDoUWHJFY2TqeR6nIA0irb8LFOOwu9Q>
    <xmx:j2roap_QVA-JMeZHZekw-tOmjtQ9eQ3o1S330a6JJgqnEcqtRZWeCA>
    <xmx:j2roapK_aO7bazUu7nP3YovwyCvevzAmnrS1N5YQegd3wGzo5tX_TQ>
    <xmx:j2roalvjPyX53OFr2r4rBbadNnx-f2uYWcONrabFHRNWY8oFE69K3Q>
    <xmx:j2roaqm-_Rx3QBkxnBFStRGB8WFm-YBv6LG5VA8y0WpW8GPRjZgch2eo>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 2 Nov 2026 05:48:46 -0500 (EST)
Date: Mon, 2 Nov 2026 10:48:45 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, syzbot+10e72ea5747737bcd2ad@syzkaller.appspotmail.com, 
	Songsen Yang <yangsongsen@insta360.com>
Subject: Re: [PATCH] mm/vma: read anon_vma carefully in validate_mm()
Message-ID: <auhn01dpDzK47igy@thinkstation>
References: <20261102-fix-validate_mm-v1-1-5c309614ef15@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102-fix-validate_mm-v1-1-5c309614ef15@kernel.org>
X-Stat-Signature: npmmmkhif76nn3dryqfh9wehngnppwp9
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 588BE20002
X-Rspam-User: 
X-HE-Tag: 1793616535-946589
X-HE-Meta: U2FsdGVkX1/9kBw7QSf/9JVj1dqSJD6K2AVHu8Mnon6NKhguePzDxT6cEZqW2JjirKOUBXx76s95TJ0sRw/mSR6CJ3UisI7s1sHoMdxIYipH5K18/A+UWfDQ33vMKE8NRmCgq/7y5RKGZ7LisaVJunbaORXLbEuCwSu02D/5+KdcXQhi9vK2vzCYWu7jhBPogQV6be8jzJ+j9iSzIZaBP8f08CJo4t5xyEb3DjZNtP8pS/rVfYRyOM+vsfyS1YQ05Nqq23U85tkGvBsP1rYAJfQ082cN2YhFfknEMNh2fZTRci26QkqfGYSTEFgo1Y2++pSDL1F7t+syx24SK4Cwl9PvkZfHx9Rxu14ois+WArXy0UPalDA/ttd+5XEniA/o696oq/oLpYsZeSIkmEzbag34lAzSgTu6AAhCNUwF4vf46znoPBu90norbm3FP9JMDc6lpkCUS531jZTQpk1606LI3iYikYeMQkHUeSgFrRpFAN+Lrf8aAGTQ7QvanPlbJlpPZ9e+i4bWBVrJUvWF36do4EkqhEv2g0jxvn5ucVnKbML/QhbZOJXPah4/giiw4pyHTxZYA+oPZIMzU7gUMwkSajHZnGD0tDDxGWCmUaKl+uS3Yls2+CztVIAOJrZnbhADBPlbarSbBkLf1qdgbVm/MyoEYRqls/CnPshOJQVmaduZs/Yz93f0CqP4iWDUC+6nZHMt35Bj4CiYOY+bjt5RsbxQMa91Oj8RzeFX11TOgmwqQdRU5p5NcDCxgLckLiXLiowfideanjpRNSliDjdkobgBZ/DD+X1YeJwpLMWTYYyQV1yPj9ae1/68DiJzLmjMMNWr1v4MMksKFeGI9+aLdg2baQBvY25jSWN/B+cW3IXhU78LysWv3HxjfrL0pyEhvu+QKYatPT1YE7Lq8r+cef6cmBbt/anBshsbC66zfIfATx8pRknwgWcbtGOJVruvn2KD0Mik+ZnGX0v
 pr6Lz2/D
 8RNgpSjcoprd6U4/hI++/hbVrl5pAJGE6C0TPkN6RizHEX4StntDIfP0D0D7VmETYwbi1izh2ooD9R8yf6RmMbJkUq0Uyitl+nFEqnovUA+eis8I6m1gcUBPPLKwcQR6EXQ+XKvaIZYllJYsgztLxDjYfFgFAcVs7AEoiNrir8SmjiQrX1JgksmUkFkLhPs1pfOu5g2g8Ffm+PNw0wWKbjkuZMWa1aOeY5ZMAHwX0ovrXO9LhnvdZQsE07j97L920O2ciF9VK8B38tNSWvw7bq4F23d6iN66YUOOTt1Vr+5D3kfzxYQ2OeCR/fjcgaOBTr9hbkgbdePZ2x4rpfc/qOKj02kLfcAoqQB7Nx+f6kL5q8lNC5ggWXszFrK1yjbdQeK7luh5+vo/l4uteZdf2wYzGPfSgYrV/NYpNEriuzbG2OWwcOWHJcYZs9soPTe/9ni2c0olJFC6w817v/Tylo8VSWVPGv8lwR0yezNC0W4NHV3WVq8Q+o9gGrCYO0f8EmuEW8aC4jDAjSR7JIp1IGkJYDxY36E++bTYIxDxY+DsIfsYqQMfBHpI3384YqcebWVrH5MnMPUY5sO0puZP8eyL1Jqv8Tyy8soeukDeX2zZIx7Z6kvzagZ7ACQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 02, 2026 at 10:25:20AM +0000, Lorenzo Stoakes (ARM) wrote:
> Commit 38564710f443 ("mm: implement and use vma_has_anon_rmap(), silence
> KCSAN") rather clumsily converted the read of vma->anon_vma into a
> vma_has_anon_rmap() without accounting for the separation between
> assignment of anon_vma and later use of it.
> 
> vma_has_anon_rmap() is intended as an optimistic check, so doesn't need to
> protect against a torn read in vma->anon_vma. The caller is expected to
> take care of this themselves if they then in fact access the field.
> 
> validate_mm() does indeed then reference the field, so resolve the issue
> via READ_ONCE(), and simplify the code by separating this into a new
> function validate_mm_anon_rmap().
> 
> Finally, add a vma_assert_stabilised() to make it clear the required state
> of the VMA.
> 
> Fixes: 38564710f443 ("mm: implement and use vma_has_anon_rmap(), silence KCSAN")
> Reported-by: syzbot+10e72ea5747737bcd2ad@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/6ae78418.6552420f.2a0efc.005c.GAE@google.com/
> Reported-by: Songsen Yang <yangsongsen@insta360.com>
> Closes: https://lore.kernel.org/all/20261102074414.10902-1-yangsongsen@insta360.com/
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/vma.c | 36 ++++++++++++++++++++++++------------
>  1 file changed, 24 insertions(+), 12 deletions(-)
> 
> diff --git a/mm/vma.c b/mm/vma.c
> index d416ba58eb4c..9f02f19a7845 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -669,6 +669,28 @@ static int dup_anon_vma(struct vm_area_struct *dst,
>  }
>  
>  #ifdef CONFIG_DEBUG_VM_MAPLE_TREE
> +#ifdef CONFIG_DEBUG_VM_RB
> +static void validate_mm_anon_rmap(struct vm_area_struct *vma)
> +{
> +	struct anon_vma *anon_vma = READ_ONCE(vma->anon_vma);
> +	struct anon_vma_chain *avc;
> +
> +	vma_assert_stabilised(vma);
> +
> +	if (!anon_vma)
> +		return;
> +
> +	anon_vma_lock_read(anon_vma);
> +	list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
> +		anon_rmap_tree_verify(avc);
> +	anon_vma_unlock_read(anon_vma);
> +}
> +#else
> +static void validate_mm_anon_rmap(struct vm_area_struct *vma)
> +{
> +}
> +#endif
> +
>  void validate_mm(struct mm_struct *mm)
>  {
>  	int bug = 0;

This ifdeffery seems unnecessary. What about this:

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 9f167950926a..2e43077dcd51 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4363,9 +4363,7 @@ anon_rmap_tree_iter_first(struct anon_vma *anon_vma,
 struct anon_vma_chain *
 anon_rmap_tree_iter_next(struct anon_vma_chain *avc,
 			 pgoff_t pgoff_start, pgoff_t pgoff_last);
-#ifdef CONFIG_DEBUG_VM_RB
 void anon_rmap_tree_verify(struct anon_vma_chain *avc);
-#endif
 
 #define anon_rmap_tree_foreach(avc, anon_vma, pgoff_start, pgoff_last)		 \
 	for (avc = anon_rmap_tree_iter_first(anon_vma, pgoff_start, pgoff_last); \
diff --git a/mm/vma.c b/mm/vma.c
index 1be613044b4a..30f31d3b3e26 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -669,6 +669,26 @@ static int dup_anon_vma(struct vm_area_struct *dst,
 }
 
 #ifdef CONFIG_DEBUG_VM_MAPLE_TREE
+static void validate_mm_anon_rmap(struct vm_area_struct *vma)
+{
+	struct anon_vma *anon_vma;
+	struct anon_vma_chain *avc;
+
+	if (!IS_ENABLED(CONFIG_DEBUG_VM_RB))
+		return;
+
+	vma_assert_stabilised(vma);
+
+	anon_vma = READ_ONCE(vma->anon_vma);
+	if (!anon_vma)
+		return;
+
+	anon_vma_lock_read(anon_vma);
+	list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
+		anon_rmap_tree_verify(avc);
+	anon_vma_unlock_read(anon_vma);
+}
+
 void validate_mm(struct mm_struct *mm)
 {
 	int bug = 0;
@@ -678,10 +698,6 @@ void validate_mm(struct mm_struct *mm)
 
 	mt_validate(&mm->mm_mt);
 	for_each_vma(vmi, vma) {
-#ifdef CONFIG_DEBUG_VM_RB
-		struct anon_vma *anon_vma = vma->anon_vma;
-		struct anon_vma_chain *avc;
-#endif
 		unsigned long vmi_start, vmi_end;
 		bool warn = 0;
 
@@ -702,14 +718,8 @@ void validate_mm(struct mm_struct *mm)
 			vma_iter_dump_tree(&vmi);
 		}
 
-#ifdef CONFIG_DEBUG_VM_RB
-		if (vma_has_anon_rmap(vma)) {
-			anon_vma_lock_read(anon_vma);
-			list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
-				anon_rmap_tree_verify(avc);
-			anon_vma_unlock_read(anon_vma);
-		}
-#endif
+		validate_mm_anon_rmap(vma);
+
 		/* Check for a infinite loop */
 		if (++i > mm->map_count + 10) {
 			i = -1;
-- 
  Kiryl Shutsemau / Kirill A. Shutemov

