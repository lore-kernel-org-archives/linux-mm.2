Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C462FFD45F1
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 00:41:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 288576B008A; Wed, 25 Feb 2026 19:41:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2697D6B008C; Wed, 25 Feb 2026 19:41:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16BD56B0092; Wed, 25 Feb 2026 19:41:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0452C6B008A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 19:41:51 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AD6D6160244
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 00:41:50 +0000 (UTC)
X-FDA: 84484755180.06.FD21238
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1E389100003
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 00:41:48 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=CcOiuO7N;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772066509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kzBboXRq2m0Xbzbb5Eqzgnd6HDbE7nrSUbmDE0s8g3A=;
	b=Z9joCK91mEUleOfEnN/q3Pxkx0xeFl+lr4voM5H12mA+sU/dInWjpKGmW5jd6IiGd0ahs+
	xczPo313mwnK6mlUP+jFU++KGN6rv44mmg2DdL0gIlWoPZAQUUCjmANZctZaQqCrcX7r8x
	5S+eeg90xjSdeLQyQlf3byIzfV+YThU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772066509; a=rsa-sha256;
	cv=none;
	b=WsXx1m0UcoCcasTWtgcHwUVJEv4hchjZ3f40ql2PV3dMH59Il4VYp7p+nmsft8sbySoato
	a0xRDDuyd5bwUk22WALJQwpPL6VJLy1uU2YPlBPgcuVs8tDXyalj1o4gEPiJxDHcYC2q1w
	dGLNAj1qaAZOejoQLROOswk4uXTEc4E=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=CcOiuO7N;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1381C60053;
	Thu, 26 Feb 2026 00:41:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03CC4C116D0;
	Thu, 26 Feb 2026 00:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772066507;
	bh=a5b15Ngqo2bOOdUHSjsT/sSuPPfkZQCQF/naFXI2QkI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=CcOiuO7NEI5etysy42JpjnremhTiWgG4lUGW8vs+Kti8TdTA3xkAw8m9bRPHQw/jW
	 UtviHmXGTs0EojsHSlFb7e+3Lc6f61/dMS61S/znrah0BD8VlKfWckTXVq5rOTTIiN
	 OwOPmCyouWxjyK/Ldx7pApiM6o9/4J5sMHRRG9vY=
Date: Wed, 25 Feb 2026 16:41:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: David Howells <dhowells@redhat.com>, Marc Dionne
 <marc.dionne@auristor.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu
 <chao@kernel.org>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Chris Li
 <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Kemeng Shi
 <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He
 <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Matthew Wilcox
 <willy@infradead.org>, Dan Williams <dan.j.williams@intel.com>, Jan Kara
 <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner
 <brauner@kernel.org>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger
 <adilger.kernel@dilger.ca>, Paulo Alcantara <pc@manguebit.org>, Trond
 Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, Mark
 Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, Joseph Qi
 <joseph.qi@linux.alibaba.com>, Steve French <sfrench@samba.org>, Ronnie
 Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N
 <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, Bharath SM
 <bharathsm@microsoft.com>, Maarten Lankhorst
 <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>,
 Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi
 <rodrigo.vivi@intel.com>, Tvrtko Ursulin <tursulin@ursulin.net>, Chris
 Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, Ilya Dryomov
 <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>, Viacheslav
 Dubeyko <slava@dubeyko.com>, Andreas Gruenbacher <agruenba@redhat.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Ryusuke Konishi <konishi.ryusuke@gmail.com>, "Darrick J. Wong"
 <djwong@kernel.org>, Chuck Lever <chuck.lever@oracle.com>, Jeff Layton
 <jlayton@kernel.org>, NeilBrown <neil@brown.name>, Olga Kornievskaia
 <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Jason Gunthorpe
 <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu
 <peterx@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Jann
 Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Brendan Jackman
 <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>, Hugh Dickins
 <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Axel
 Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei
 Xu <weixugc@google.com>, Qi Zheng <zhengqi.arch@bytedance.com>,
 linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-ext4@vger.kernel.org, netfs@lists.linux.dev,
 linux-nfs@vger.kernel.org, ocfs2-devel@lists.linux.dev,
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org,
 gfs2@lists.linux.dev, linux-nilfs@vger.kernel.org,
 linux-xfs@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v2 0/4] mm: Remove stray references to pagevec
Message-Id: <20260225164144.76e14a362e0d7cae49f20787@linux-foundation.org>
In-Reply-To: <20260225-pagevec_cleanup-v2-0-716868cc2d11@columbia.edu>
References: <20260225-pagevec_cleanup-v2-0-716868cc2d11@columbia.edu>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Stat-Signature: pnjnsyzn4mgcpuoidzik64jjpigkuybz
X-Rspamd-Queue-Id: 1E389100003
X-Rspam-User: 
X-HE-Tag: 1772066508-569267
X-HE-Meta: U2FsdGVkX18CsYtUmNTT20YCUpP5ihPt35LghtB99fFHleOW1RSKURTQTJxlqvBsv2Rez3Q0IbtLJrKGZqHb/ggVfMj9ggJHX20tDthSRqtO/Qu3+KElOgLMQuz8oqE36d3IboGErAYGKAYPpaYsj3jWL3x2czSVR9N2v/m6wAPYoz3jpolonS4RdU3W7OFKDzrxTfWarCmxwjZBKu2SU8bVniHizhVgoBuTIqlyrIqWfWa7c2HGQhNzlZ3Pc+igXquPJRa6zCprDx8edPt3JGXFg5nTKmmfpdsu+xrimVNnQr18ujEY5BIe9Y6kxPZHOvMuJ4GbD9yn1QFFL5YojJ15QujQ23ZFkRvGyAaVUoYGAg1wOAD42Fz+y6zjzZ/u5A8CxDPDKY1EkxY9x02KtNBUCiUNJfCry92eEq5gfdTdpLSwu0hWMzAocLfTofQApOMhPOwhNLxpsmS+IaUEWI5jDy2dbTPRcv44OPzJ3vqx79VOobVtJJWLxxkzKJ9MBI53ST6PoS0K6WLCLuj2Ai5JL7XtisQDZvAtMri/gOV65hFo+eWAjzKzlLy3I6oG5ENOX2MwlyEXZjHw4XTL0F5RtLn7HB2Y4/ASXJDfxBp9wgjcc1nCFrvWgKmNMgcnQTIfFZObo+cuVlY8PPZoEb323FQ58OycToShwK6fzmAjPw/NVB7xiQxsMt2robkxir39h5dd7xqap9UmDdT2JggKEnNbs4PNHNW+xGZqyMlDhjMouf85sOlgxw4LftnDEFaa4XeMOsGHuZAXkGOp21BiaP6/HweX/u2hmAP7w7YSGj5yC0VyFluCLbVPr0nQw+uPAvsYY2qNFtGXrhOmoSKHmkrVHX+iyMLyAO8aqTN/R26wHSNXmsw/toCAB5vwLD/GSv2MjECdD/0v0EFvTJWKJBQ3xj2K1XYE7JPIc3a2g62TZnr+bvdzDM1sSmf/+BYxkk3wPrRNwKClrmz
 jGGNqz44
 g8vYZqOM7XvdI3rd1l3WRKesU0lTtw4Pkd++KB/SKIeLZ01Y1dixD3HhEyZ6dmVKVs2HMnPCGyLy6RujbTUQG8JZdz69qavGCIeXt3uXjriGr+TY+aM2K7Qr/6QaZuIXlmuoOayaKGlscWWnRW0/C9IiUnNQPdjrzMoM4uPwNDdCwPGd+PmTX0VKh4c3gz8aYJJoVXPuJMemyVlG1HRd9TtJqHK9ZawRVKvM1csSebTq+9gDchd7dTNlcY+ySyY+IkqPJpqTeJUdL07gkhJaVhfyuJGiawGDkPz15Q69LGdok3SqaRtt/rqeX64/pNTMZJu54NZyJWswBqwG4ogx6qrVP0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 25 Feb 2026 18:44:24 -0500 Tal Zussman <tz2294@columbia.edu> wrote:

> struct pagevec was removed in commit 1e0877d58b1e ("mm: remove struct
> pagevec"). Remove any stray references to it and rename relevant files
> and macros accordingly.
> 
> While at it, remove unnecessary #includes of pagevec.h (now
> folio_batch.h) in .c files. There are probably more of these that could
> be removed in .h files, but those are more complex to verify.

Dang that's a lot of cc's ;)

Thanks, I'll add this series to mm.git's mm-new branch.

