Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B4C3FF8850
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 02:38:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51BE06B0005; Fri, 24 Apr 2026 22:38:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CCCB6B008A; Fri, 24 Apr 2026 22:38:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E2876B008C; Fri, 24 Apr 2026 22:38:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 281596B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 22:38:34 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 473CD1201E9
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 02:38:33 +0000 (UTC)
X-FDA: 84695519706.23.8E3F27B
Received: from relay.hostedemail.com (unirelay01 [10.200.18.64])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8A3E34000B
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 02:38:31 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777084711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=GqAlbzim2Q1p1t/hFGibmsvrrZ8VDQ1QmtSnpDyxHMI=;
	b=mOg42hWK1Sqro5dIboLm9PUlc/iN5uFASoJRroO8V9B0oOjbRvl1VQqQRFGoLDfvEjFozz
	wlytyPAYaZrsp47mhStjBI/5gIXPC5nZiCMKOawhREDhA6x64uO8rwqg6yhkIaCMwIt7l3
	K40BHc5Kj1tUnBXmXa5zt3B3qfjSnPA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777084711; a=rsa-sha256;
	cv=none;
	b=kv1Jwl5mpGc+UgvO48aHiC7Dq+w8vFF4VEOMht9lzeuhDSyOIMeCRhc/5mnYJP0JzSn7y7
	rAgTrrJ70b9Ayu1UPgVUXJUOnPOLhvEcpxj72oJGNfDUek0FtuDVSflZ4zhTXwTuHyQc8K
	X3m0hfkiCtWcwVp6JfsuqGFVG0el9DY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	none
Received: from omf10.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6463E1C004B;
	Sat, 25 Apr 2026 02:38:30 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf10.hostedemail.com (Postfix) with ESMTPA id E9AB141;
	Sat, 25 Apr 2026 02:38:27 +0000 (UTC)
Message-ID: <d9cbb89faa5bdb71d451781d214a51ce8923a83e.camel@perches.com>
Subject: tools/testing/radix-tree/maple.c & vs | defect
From: Joe Perches <joe@perches.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Alice Ryhl	
 <aliceryhl@google.com>, Andrew Ballance <andrewjballance@gmail.com>,
 Matthew Wilcox <willy@infradead.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Date: Fri, 24 Apr 2026 19:38:26 -0700
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
MIME-Version: 1.0
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX194umgHdIYoRNTpdu9d/3eZyUORtsdGRtQ=
X-HE-Meta: U2FsdGVkX18LeMnRkpOCimFx/8VLdJRKH1py04izRhSyBzAyo3q6uSc+k2t4J5m8EMMIiO8425IdFvdUpi2Qf8HLq8gMxvYVJGyVw3Zfj6cexdS3YIXky+0OtZOslPEqrTYONh7RK9nhEJMzcCmOrncqP/du51X8NzNCEan4reChKsFpzx9xWcD9eXYYPqiWF5wfB5/ftaABabllo145EYKsYwBaQGxlwPnSyDrj6SnctuuEMM+fB/xS9KqgDsE2tqjgNhd0xyTAo09L2xAVPOE5W16iL+STfDvcUJS7DTcnuQ9MCo/UjfYis46+kq/o
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8A3E34000B
X-Stat-Signature: d55j4uznx6scuko39j8d9go9rn7ayc5m
X-HE-Tag-Orig: 1777084707-41909
X-Rspam-User: 
X-HE-Tag: 1777084711-470051
X-HE-Meta: U2FsdGVkX18ZsbTxNLJTeR4Nh9gFikRe/5+I0aZM5uHlSJ5ubEUTQEp+V2pb+pRW/dS4jfwMv6Czt3nrMvF/ycN7n3tRIj5TaBqOB5r2Q5FnjTS2czJbSV4IXacA+kH1bAOLp0+LHxAkIsz6yef679bc2/cZYeiV6+zdWz2vDHyvg3DMGv4F+VcsS5D82cQsg+pCUPpkMRpYJN99+oET6sVmmogAoDOKoYhmQ9ZJ32P/WQWkwSYq0+fPCc2T9q/wimezgm7zTWqZsIcBxb+z/hzdHEQHXLzdg/6AuxW7p3LB6eMbaereHTIl4PmYvoBj2RfgwWEoMF/9erLnY0f5TgkUeQ86QvMDdDsNPKUKAcdm0eDqDTRrxxOAMXVaOL+QGPPPAoOcsmlswC0zavBncAaYxy65RP1kvHK8Ep+b7nHedgjlRmV/hbzBqImOJw/kXPb2MmKF2TFmjxqYbZnfgyccX3CM37u+osto8ME0DuSMvuRTTsI88CYmusAtcDkfIC4UbrjW3hNLsQDt08MUhrYknUAwrm1Mpu5Xkk4DbRC1DjPI/tfjDcBqPy7Sa7OMpozkcOzoUzJZpDtpxwrOENX8DysAdijYNkNg64sUDxJqMwF0J3redPmdNFRbYrxOqoSlNOXw5o7iR5No1qhJfRC9i5Sxu3K640Vo4a7u2WbMCGiQOR0UtX5lCI1Hwxr/xweSTEvcVstKuv35MRcNerEMtEPUvdI1Rht2532ed/mr9gdLJvFwsDmoJgdqVh9yqeEvVJ/JZ6FsniM/tBhCp2mQKWv/FpYxpFLOsS8sA0iXMIvhvnUf2moV2deWeStf4IvsMxNp4T3f8TOq5KIIiVM//1j+qrZwwDGSY9IodYCw7gCOUlB12DFkrTKej4LdK72f+QY2XfODS+N+ID3OPqr3UcYnATZr/0pXjrieCy/bPOv+8tcFMo4slpa4BvdE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tools/testing/radix-tree/maple.c:       MT_BUG_ON(mt, mas_preallocate(&mas,=
 ptr, GFP_KERNEL & GFP_NOWAIT) =3D=3D 0);
tools/testing/radix-tree/maple.c:       MT_BUG_ON(mt, mas_preallocate(&mas,=
 ptr, GFP_KERNEL & GFP_NOWAIT) =3D=3D 0);

Presumably the & here should be |

