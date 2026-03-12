Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B8C7106ACEA
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 21:14:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D1186B00C0; Thu, 12 Mar 2026 17:14:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3548C6B00C1; Thu, 12 Mar 2026 17:14:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 261166B00C2; Thu, 12 Mar 2026 17:14:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 11AFE6B00C0
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:14:32 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B0E3A1B74F5
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:14:31 +0000 (UTC)
X-FDA: 84538664742.15.FA724C9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0BCC8140013
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:14:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Duh+dhDj;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773350070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JyaGHRZ3ZkkbnQmXol9kjS74w6GitWq98nUjpBQHQFI=;
	b=5ZQs/Tac+5x98HON09JcG9G88yg1O99zxFtVU9cvpratgRKSjfgRfX/XEDZoSFiUAwEqtS
	NDCuhfd0KIJOOvX/PyxIbyUpSt6ZVlyRyeqaIhLZAqxe+iBTrQAppYgWIw1K0L1WJ6k11r
	rZg5aj39X4SaTtH3V1w0K5QymeYvYdc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Duh+dhDj;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773350070; a=rsa-sha256;
	cv=none;
	b=XikSN+gTC1Nptsjbvb71Xdas2aOzKSC09FmVSR7Mr3zrQb1SsCrZx+6nu4BoYBvxfMmBXo
	WiteTWoCzLj/NbC623ZBOGVxXZd+ZwOZPVibF6A6/fznIqR/oA6152RblmYPa+Et7SQpie
	IMjrwh0SR1bG5W4+Y6vkpPjOj8tjmXk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 03C6B44398;
	Thu, 12 Mar 2026 21:14:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3794C4CEF7;
	Thu, 12 Mar 2026 21:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773350068;
	bh=BHIeqMCeZ08yvAl5YqqjtddRClVSOvGwSHug5GXzEz8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Duh+dhDjn9i3oyIucNjLcpV7CKSwWMDBwP1nrAeCAWcyGXtDakHpRp+pm3kMEvL8y
	 SEaAaWk5jP3gQGaz8kV5kaoD1HdJgTdnHuWBZE8KvOuDSG+7q7krHiTC3YYNdfGDfn
	 Xpz6tLlo5tMrkq0Sz1LyxlbqOsozNn9yfZFUkN8M=
Date: Thu, 12 Mar 2026 14:14:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Clemens Ladisch <clemens@ladisch.de>,
 Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, "K . Y . Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, Alexander
 Shishkin <alexander.shishkin@linux.intel.com>, Maxime Coquelin
 <mcoquelin.stm32@gmail.com>, Alexandre Torgue
 <alexandre.torgue@foss.st.com>, Miquel Raynal <miquel.raynal@bootlin.com>,
 Richard Weinberger <richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>,
 Bodo Stroesser <bostroesser@gmail.com>, "Martin K . Petersen"
 <martin.petersen@oracle.com>, David Howells <dhowells@redhat.com>, Marc
 Dionne <marc.dionne@auristor.com>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara
 <jack@suse.cz>, David Hildenbrand <david@kernel.org>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato
 <pfalcato@suse.de>, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
 linux-staging@lists.linux.dev, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, linux-afs@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Ryan Roberts
 <ryan.roberts@arm.com>
Subject: Re: [PATCH 01/15] mm: various small mmap_prepare cleanups
Message-Id: <20260312141425.1837736829210f2d0b00cac6@linux-foundation.org>
In-Reply-To: <56372fe273f775b26675a04652c1229e14680741.1773346620.git.ljs@kernel.org>
References: <cover.1773346620.git.ljs@kernel.org>
	<56372fe273f775b26675a04652c1229e14680741.1773346620.git.ljs@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0BCC8140013
X-Stat-Signature: hp3zqehctpx87iryk8ednhdky7ej7dyz
X-Rspam-User: 
X-HE-Tag: 1773350069-402089
X-HE-Meta: U2FsdGVkX19gmlCBlS22O/ykTpmQkkAWrA0x0G0r9SSuXGJQbygfyywQomxZq5GVBxot0TIhmmEzGzKNjwXFZQ4x2YoDbe2Yr0JbOdjzy6qpxHSRTsDQLAe7v1dkhJqaPPGglWcRWM/kW9hbpm7rvjn9LKawuU/MpjyGblMyQk3Eg3RBVSdI4dThUeKyOdZ+7edmt8dka5wYAkKcAuJQ7/v/9MAwWBiFJtC6qLTEenrFtQvQYXsooLPs6EewHJXQwWnFPHdjxYLioxDg2+aO62Zul1bh1tpm4JyOjpDxSjqES/CIdLUQ7AzVc9GCP3MH5P9Iiz0zRAz0NCUJwSsM/Kf1Tizar+rvjN6qIbinqXOyLmuya6cqIIfBtkYDLVg/y208+V1wxXcOuauu+au/B2rw1phIxYeBireaFnV1oEOJEGP1Oa3X7p9Ya6nKiSNY/ZQuvNeD934tsmH4MCHSwh/jiF6Krvp0C0GxjSVrX4SsPmZAwO2Tp6wOu5Y0pti0C4Cpxu50nfOJIru+Xil2WUVGaF43g9PX1yYhl29T3UaNJ27tGf9tnTJ9Gwg3qkP8vnjGdrP9bWBYKZ3s9r44dtVvf91Fo456EbxuOIag4bSvooeZGvFrj65j6dbolCAmRsbpeFd/UEuWfgm/G+jWSwT5kWe/cAIAbAJ3p21F62q+a/dBbJJ05ZzqoFwhzTnA4fBl/LWAURh9R59prXdwXUme009AvJTSY58EutBCsZ3R3/I8FPEC0d+kMgkVSoGabcBtUjpbL4GN438t+dsib/n/C1cZatjailjYSxMyI8VTdyBn+227Gilo7V/BVTIy7vIqNhF3QvYNtN8gyKXLjKBlDkVAQM+lW1dyxsZKe0iB/U9SnT2awyL+zpp9JRZsuhOaGImun/S0kXK3M5JBj9dNcMhwYuv7VDTgYb+uZAJJq0Pr7B8yb2lZYGf/vbjDWUNDBTwua1P+7kp9zSG
 SwVZxYkt
 CE3tduz+CarJoUu3eoZ+EwDcIbeB79+39Yhiergj0yH72BlyPk8cG95ZK0/zTxNuSvmi2LxCd507B9Cg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 12 Mar 2026 20:27:16 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:

> +int mmap_action_prepare(struct vm_area_desc *desc,
> +			struct mmap_action *action)
> +
>  {
>  	switch (action->type) {
>  	case MMAP_NOTHING:
> -		break;
> +		return 0;
>  	case MMAP_REMAP_PFN:
> -		remap_pfn_range_prepare(desc, action->remap.start_pfn);
> -		break;
> +		return remap_pfn_range_prepare(desc, action);
>  	case MMAP_IO_REMAP_PFN:
> -		io_remap_pfn_range_prepare(desc, action->remap.start_pfn,
> -					   action->remap.size);
> -		break;
> +		return io_remap_pfn_range_prepare(desc, action);
>  	}
>  }
>  EXPORT_SYMBOL(mmap_action_prepare);

hm, was this the correct version?

mm/util.c: In function 'mmap_action_prepare':
mm/util.c:1451:1: error: control reaches end of non-void function [-Werror=return-type]
 1451 | }

--- a/mm/util.c~mm-various-small-mmap_prepare-cleanups-fix
+++ a/mm/util.c
@@ -1356,6 +1356,8 @@ int mmap_action_prepare(struct vm_area_d
 		return remap_pfn_range_prepare(desc, action);
 	case MMAP_IO_REMAP_PFN:
 		return io_remap_pfn_range_prepare(desc, action);
+	default:
+		BUG();
 	}
 }
 EXPORT_SYMBOL(mmap_action_prepare);
_


