Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6081606A334
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 02:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mYXsdtTD
Received: by kanga.kvack.org (Postfix)
	id 5DCFD6B05B4; Tue, 17 Nov 2026 21:00:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B50B6B05B6; Tue, 17 Nov 2026 21:00:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F1456B05B7; Tue, 17 Nov 2026 21:00:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2EB566B05B4
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:00:36 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BBC3B1C3F5C
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:00:35 +0000 (UTC)
X-FDA: 85446585630.07.C06169E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1C9AF8000B
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:00:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mYXsdtTD;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794967234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2gdho5K/JlFD0r0e2kCZivjc5YfVDRgpJ3DbV/tzMlg=;
	b=qadL3IUVLcwQzBjBtkk5PUlGrjOUkXY3RytaXJdyJSpRDnOAmbrtcXjJjBCfPd8vLOaX/k
	mxIE8yyD8NFUXCd2saBfTdClbXXjziw3pFpcp0lCpIWEHxxppfl4gLwFFKzO9KzV5cJnMO
	k6tbwTLSfKck9P0TPHMAY2kQnr8yr3Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794967234;
	b=eq6/t/5TxnPctWojNudL6GqOLkHQiNxSQN4Cs9yy5yw4ip4EXCOFsRTz1bihm24z5VM8nl
	i+45A/HJS8lEpF+fw5c6XMfBgm53dvBgM0hYgmZes5LOC5bghz5/jWRy2rcGF2qUJYAxe4
	Tomiq6z+cVvdf20svNFaugJ78s3ffUc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mYXsdtTD;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8EBD561D32;
	Wed, 18 Nov 2026 02:00:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D1C1F000C4;
	Wed, 18 Nov 2026 02:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794967232;
	bh=2gdho5K/JlFD0r0e2kCZivjc5YfVDRgpJ3DbV/tzMlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mYXsdtTDCsA/G2cB9aWifx3HlZtcFdP0G3GuyTu4fNiJ91gDGzT7qe+QSEpAipXew
	 omLKf1qYKxxyuJYgsLiL182a5d/bHFbTFl5sqQGObEQ25s5IT2vRuDOATmUVCjsg2s
	 1q1ujRTsCp3KKkeY/Wuq9RanKG+0mBqj77nslOZpbHBW/hwQN4oXB34ZSLzPHytAkk
	 mcoXCApif23tP70qMPjGSx0/PU+Ae5hQZdJ3WvHS0jlSVlNzLIv86kc/bcDd6WgtDk
	 ZVugnoINPfkhST/kRQVuzJ78oJdydcPiOsd6ipYOY23LjOCntukhABVPTPPbI7Y0QN
	 CdzNiHSrH2JRg==
From: SJ Park <sj@kernel.org>
To: Mattathias Pinchover via B4 Relay <devnull+mattathias.pinchover.uber.com@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Mattathias Pinchover <mattathias.pinchover@uber.com>
Subject: Re: [PATCH v2 4/6] Docs/mm/damon/design: update for sz_ops_filter_passed_last
Date: Tue, 17 Nov 2026 18:00:24 -0800
Message-ID: <20261118020025.97097-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261117-damon-sz-ops-b4-v2-4-439888fa04ac@uber.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1C9AF8000B
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: w78ig5nnfytin665x4ek8yhs7fq446rh
X-HE-Tag: 1794967233-954159
X-HE-Meta: U2FsdGVkX19lIu6LOpp/l8ArckLdejTnqt54mIeDZXw8mJBTwR+K94t/QUP6SlhHEwtSaOa/2K79pIlYyy0XnyPhtwOg5tEpzMYnO2nr1ysfRhSL6S0yt8X0h1c+mxoJKk4vtcH5mfEaZEifIIlY+qEJBY1sA1URUF2sKrQxT6u0PfW4zyuRMM7oWCt8VUt266b4q3nlMlW8cZunDbqAUQ8XOk/4yQ66G28Sjl8YECJO+2IRm952cDaCequP88vQl46hKOGPiSzRyABa/LGPt+18yDMkOoDjg0Yt6Y09fjMnNTX0jW7WMAR99O0B543a8hKj8Fae/yUNLK5omRpsss4suk0bIDSge53CUv5grd2prwi1AizriZV6jwG3zDpJ0q8TfHWBFqMPGZrjkSZaVWXys6xVQfUqKOd8rUrWs3yjBAPmH0pezIFOwBJ+rEXdIgx8iB9XvS7Eu0m6qZhRACzMeg5UmGJDPY4ymm010U9yl2LV+rdUd2nRHlgHJmBkZM/U/rlvidz9KXBT1rJPlYfZwHU9zQaKAC0FvJX0eqMVCtroY/v5Aepm7DVkzEWpXpGzZAg4bEPpfmLAyJ9lzv7LL94D5wgEVjkAfcyxD6GavPAX/4y5KGEWD/ToKt2APliDCRymz/t0zVIRpF4Yr2mdr8RMCSOgKxC+XpEMjcLxG4BUxpMCVA4hk9+0wj9gRoB+85uK+RvbeBfnWMAuKgUGsZ/SdVu8zppaGesrm8HENSbdIKtst6531WjMGKJFzztDkLoTvnkwgszOlwchfEa0TlpkVNsgDo1akuJ/kypyvWR8uOAV4TPNntEcnHR9LSyPtghRE5ZQQEi5Hn/UAJHDfw7dJuFJyVdASw8mP+Ed5R7BbSeWFXNyknwVcK59Oau0Ji8AdgZsDQ712h4ZJcux1c0wqP03djDQ0AVCUoBunAXH0KVqnSsPwu1Vxl2jaBIvdkME2oVlzh4Pw+x
 RRFBfy2I
 L9/HaMXIAAt6mrqy2v8LqeSlYSOSKU6YCgETtqItaGpkZRcgX9UJgzjGIQfGGueZQqPWXkj4wImygr5EoUDUKadO4g4F8tQEnW5YCA6RsXj2Bmwsemt6fsOKo0TpJZKXxLfx5cHDC9TvsxrEgspshV3lHqXAI+b2+5/Ok3C/NcMGQqbQRDTg7BEDiYCZ5I0HaILk0pOhenB2ESYFyxc8Gt4+oTXUmsQQ08hwf4aoV9VVd0q/gKJMZzN7VDz2prhp5+KW0hqQ2cKtsUtuJux+y+m8nBD0MEVClqRBF3Jak1sbPUGsp0/eC3Lm7bEISe4lWkZP2rVns2hkysLIHEsc7iuXPkzre8yRFsY+T5vazEU0sZ0vxuxi7YZunLb3eASet1sOvwCZIVlhYnmd4VQqIa/AdVBC624uRoi2dA1OwDiby8J1NsbAsMHIldaYAfHo1XJQn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 17 Nov 2026 23:22:18 +0000 Mattathias Pinchover via B4 Relay <devnull+mattathias.pinchover.uber.com@kernel.org> wrote:

> From: Mattathias Pinchover <mattathias.pinchover@uber.com>
> 
> Update DAMON design document for the newly added DAMOS stat,
> sz_ops_filter_passed_last.
> 
> Assisted-by: Claude:claude-opus-5-5
> Signed-off-by: Mattathias Pinchover <mattathias.pinchover@uber.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

