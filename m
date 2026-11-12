Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC77D606A330
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 15:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b74UMPcb
Received: by kanga.kvack.org (Postfix)
	id 771F86B00EF; Thu, 12 Nov 2026 10:06:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 722816B05B6; Thu, 12 Nov 2026 10:06:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65F8C6B05B8; Thu, 12 Nov 2026 10:06:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3FA2D6B00EF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:06:15 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CAC461C39B1
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 15:06:14 +0000 (UTC)
X-FDA: 85426792668.15.A61727E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 03BB32000C
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 15:06:12 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b74UMPcb;
	spf=pass (imf31.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794495973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3QaFLESo8P1tr3i+Kl+aPkGwBQBuU5DOM0WQKz2Fj/4=;
	b=Ipe7Q+Si9S1bTfaUdt09Ex+oeMqkYNaJ68Z8GMavy+cfrKleAn9rrcKKxSVrZDvwkmu4ZM
	7xRp3FOCjGeuU2EvEIVsvGI9tlXQKwnUJjjekOzDqUGtyxvip7QRQoPDim7y1IdJM9+/Pb
	+NmeNa6KOn+NjGMaPKh5zYfYmjtqYrc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794495973;
	b=KkijUqDl7gjhvJnHckWlxxbD1G2HzXVYvOOWgKG9WPEleH3CvJY8bg2kEFAKeM1mPtqM7D
	fPaEzCUfYvdx4z9NOKaKdDmVjwSqtvjuEbpe3tGklkQh+U8hQqUqlDs4V6nkQgWNQDiTIo
	CwC1pzk41Su6iR524NYdp7TsyP9AUqc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b74UMPcb;
	spf=pass (imf31.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4A9FC60215;
	Thu, 12 Nov 2026 15:06:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E1D51F00A05;
	Thu, 12 Nov 2026 15:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794495972;
	bh=3QaFLESo8P1tr3i+Kl+aPkGwBQBuU5DOM0WQKz2Fj/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b74UMPcbNWmvg6D5i8NUpmHQ5s1gue7/SEK/9L4qT2s/FwRDq6g45eJ3dxargrj0O
	 IfUJDq5Ywa9nfWvgNZ2ri7DaO/ct4j4knW3z9iuky0N8ttekWTRHnf6uhUp6VIy5N3
	 pGEdBViCaz3BIgGhExQCG/VpzdZLz9vRUbCqBEqWpqwfWxCOSgldyUn6xWc1tHAIVu
	 Jpzfz3+lD6zgyJnTDRG7DjXqNSIYmD8ASjnpTek7C8imYFfGZKDdaduP8DVy/U00OS
	 HN7CQfkoNfMc4f13hTQjEr3cusVBJkK5Mh7d1SwGaoPhuRRAyNj/vEnY+BLNAyJNId
	 NoZ8SndGyc25Q==
From: "Harry Yoo (Meta)" <harry@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: kernel-team@meta.com,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Hao Li <hao.li@linux.dev>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH v2] mm/slab: remove outdated comment in create_kmalloc_caches()
Date: Thu, 12 Nov 2026 15:06:05 +0000
Message-ID: <179449594652.3028940.6311434157615107421.b4-ty@b4>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261112144653.840367-1-ekffu200098@gmail.com>
References: <20261112144653.840367-1-ekffu200098@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 03BB32000C
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: hkcayz68tpcmnzd1nxyqs5amxpg9umd1
X-Rspam-User: 
X-HE-Tag: 1794495972-342269
X-HE-Meta: U2FsdGVkX18H5A9HEnCwwmwg3VIoYSEDSSXVlqm2nBOLg//Iaz7prwmecSfYMQ90qRShnWAecvlJ2MTt0BIQPgvmnmEdR0TkO7nD58GG82GMr+G8vQz/hgflBwib+kgxaf3HHFKaC0G5a2FzXUKd+PerjCSOgO5+Bod4O4vZVCtuJxc+0t1AKd3PWrbUCWd3l5hE7xbGrSn6ZdsfZMrgtLLFV6iqrHJXUIOeSBclfknc7gpyuWgKU1fIj+jf7sPgJsaclIZntZvuG+53JRw6E7Ywxiz8MOM+LysmviXZeBFw6Ut4C80JbYRsart0Rn0oefACBUmas5PdTcDIGBcns4Ga50S3H1sxFH3G/+7dPXl71ho1Z1sKNJFIGknEDdiuD19YG9kr13eBwCn8eeh/YGjSN9fHXLM/PfeFxmHz95FRLZLHYSUHP/ScS6pD7UH7ZYiDLOahV+oDraxlnHI/xqEuJhoMFhdzheRgRJaTrDL0ONoc+BARrNhihkUyd/OmKBjL8QFc94Ho5AMTl2Z6eYmorE1dexAGBuLGwf6kM7D9CGw8DRs6sM1JcAhPGfEgJ1cOt03ZaFB6N3afEJ3a2RxWHA0RIGLsrkqjEJ+3T5/66j9MbJOm/i1XLxObBFPI8sECrQ/BYHVT+BQqg0FP3VPAQm5353+iHkZkZe8dS8wUozxekJd7xef/+upCaM+2pi2qp9aTZm9+5RDfH50P5whzH8VQaU6pmJhwpiGEC1MSj2/q3TqmOdezWnoCpnCIi9vMl3BCJyxB3sQ4dRD4lZhqRTxaUJMPzj6qWWxUmrbC35oApT6411hHZATf6phXQmPBPW/Wq7oNwlll63lHOLYMfvuWTAyJFOCIDKGo5SDH8kdXudeCZnPJsdHOcLTHrxB3IJefo2kaKERjPwVnG6K2sPjbFcVFG/QFMsPaGifZaekrfe92t1WmANIHLJ95nKGLTAa27KZ8hkLPK+N
 v59UhD+L
 vRqqBbBDNQVGdLUuLtn/iggy+qrGFli5G3nD5QsNgmEk+RaiT7ZhYZSAv4ufC7cAPow74ea7givqWVyZvT8ydDQK3RQGVVM5srWIDmYRxLplLs90mLWm3K+JzLD7x0boGjzH63X0tHw4+Jp/CQtab1XNIu10qHxrD0BCpOcgFhaypXP3iZbhUbmZX20VzgqHMyIjPjP40NkkWnuP259Jf+ddhXWOaIZaxJExRaoxHsj5sIi+5e1g/RmpdVVw67w+BUrYD2+XtNYdaN80=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 12 Nov 2026 23:46:52 +0900, Sang-Heon Jeon wrote:
> Since commit 16a1d968358a ("mm/slab: remove mm/slab.c and slab_def.h")
> removed SLAB, no kmalloc cache is created before create_kmalloc_caches().
> 
> So remove the outdated and redundant comment.

Applied to mm/slab.git slab/for-next, thanks!

[1/1] mm/slab: remove outdated comment in create_kmalloc_caches()
      commit: a7cdd0af963a420fc0e6f20b7c8bc8d4784098db

-- 
Cheers,
Harry / Hyeonggon


