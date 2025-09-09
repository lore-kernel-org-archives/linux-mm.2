Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA500CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 23:34:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DED978E0002; Tue,  9 Sep 2025 19:34:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC57C8E0001; Tue,  9 Sep 2025 19:34:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D024F8E0002; Tue,  9 Sep 2025 19:34:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BF4CB8E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 19:34:16 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8CC74140676
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 23:34:16 +0000 (UTC)
X-FDA: 83871317712.03.BF0283A
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf17.hostedemail.com (Postfix) with ESMTP id D6A8B4000D
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 23:34:14 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mhEcrDBJ;
	spf=pass (imf17.hostedemail.com: domain of 3dbnAaAYKCDgmolYhVaiiafY.Wigfchor-ggepUWe.ila@flex--surenb.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3dbnAaAYKCDgmolYhVaiiafY.Wigfchor-ggepUWe.ila@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757460854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=BXSTG2Hw61qjXt22u9sHybV2+YxgWVuc3hF7N60zsf0=;
	b=7ZLJlnni8Fu8mZ6jmu4iIWcWafOogN7NmMUFqmrrUYJbhcGT+Rx3CSzeewn6YnKGrinPhv
	9ZH2gq2fR+Skzaqb/tTzOnSed1V1f2UAdeeubvp63eYXoifYEWvPk2tKiXGn6/9BAYFy9s
	OHWpfzY+6jz7+Jmywg77ssFE+lTObyY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mhEcrDBJ;
	spf=pass (imf17.hostedemail.com: domain of 3dbnAaAYKCDgmolYhVaiiafY.Wigfchor-ggepUWe.ila@flex--surenb.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3dbnAaAYKCDgmolYhVaiiafY.Wigfchor-ggepUWe.ila@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757460854; a=rsa-sha256;
	cv=none;
	b=8esPuN91KH2WQ459bR6SuOwUm9wuwsydBWdhgQ7TRXqaJNqAYSptIoED7OLQfmfsQmBiKY
	cXkWs6CY3IQ7cyeUA6iS/rqxe2X5VLTNH+VCEamPaW8hGMuqVDf+zpbKfVnYIXcrJym49a
	7CCdmLTC1Tgpl61JwxfB1tCPY4vkazI=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-24afab6d4a7so128468405ad.1
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 16:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757460853; x=1758065653; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BXSTG2Hw61qjXt22u9sHybV2+YxgWVuc3hF7N60zsf0=;
        b=mhEcrDBJQTvGK+xfuAOxL7P3ScRBaJUQPVUITrSVPkQ1y1fmIjXshmuMerK1CVZA19
         K/ktSPnMk1FkVw7P1s8+aIgEWeNsjoUAG3mNEIMT4cBmGvp/j+34Jeo7mS9YTkc3IjAD
         melTeM9QU561soITtf14kwUKQYLsWrGKHFM7H5tp9SDP0BuRYFBkQvUXUaRdZvm/N5v4
         IQgMAdx8hmL5tDNcPwkET3AQCrN3qA7UUlfqENWEIfnjifXmMz7im4XyUUg0tXIUxBp9
         fhJBAl2wK19ec53M3fszovNvVgqmAWCa10F3oo+RbCTq0ikUJSGSloF/LViIrsxF0UrI
         1aVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757460853; x=1758065653;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BXSTG2Hw61qjXt22u9sHybV2+YxgWVuc3hF7N60zsf0=;
        b=L2cH5G8f9CgH+gmK81J8YRhgXRxR9SLUYDfLEhpuYyUieLJwgz49eyDa2EvIcFAKa/
         aIdqRUWiu1+uiyc9M8erU6ngRbyrd6R5CcpjRZ7dYCHS5UH94LBXh6maQTX4yuoj9Wc8
         PBVfQVkmAw0kfIbo55DA5TiBS1OptwW9L1+sjDof/ZuHzz5QrdZrCnspkimYnvwFzgJc
         FK0yE7i5+OJmvI7PfPEpRIy2f8KJ6kjJmAWdRBhyX9tMAH7xCscWVG0lQE2GdsDTLiNt
         oD1GancVGvtzaI3QxOAJFeBVIp/rCgq9vM4K2QjAlwR/2SHaij/6bL6NqFaHEEJ9Fpd4
         aD8A==
X-Forwarded-Encrypted: i=1; AJvYcCUh+zgYtjh7BLTuXhd9HFZhTc/W8ydkOaEEKYlYO+pOEo9/NvWRveRiKCji0nKHZhsjHVylMG5pNw==@kvack.org
X-Gm-Message-State: AOJu0YzM/yOBbHmklD1B2/PRTJW7vd60zQpOpAs+N1qSvQe4N48eJrTZ
	RMGQhVmDi+OVQ7YZZUzPi5ybODvxOVYNU/B/F/8WwcCnf6aYt9IaGYobPqrRLHkVuLAMaPSFUqI
	uGw2Uig==
X-Google-Smtp-Source: AGHT+IFJgHZa3+zvruFKL+nbXgevHIEGRIktfPiZlMC9mp0yCbO3eiifrGu9e5eBy2AJJ5ymyuaa+Bx3oq4=
X-Received: from pjyd16.prod.google.com ([2002:a17:90a:dfd0:b0:32d:851f:b1f0])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e848:b0:246:d70e:ea82
 with SMTP id d9443c01a7336-2516ef591e9mr226436865ad.5.1757460853523; Tue, 09
 Sep 2025 16:34:13 -0700 (PDT)
Date: Tue,  9 Sep 2025 16:34:06 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250909233409.1013367-1-surenb@google.com>
Subject: [PATCH 0/3] Minor fixes for memory allocation profiling
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: kent.overstreet@linux.dev, vbabka@suse.cz, mhocko@suse.com, 
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, 
	usamaarif642@gmail.com, shakeel.butt@linux.dev, 00107082@163.com, 
	pasha.tatashin@soleen.com, souravpanda@google.com, surenb@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: D6A8B4000D
X-Rspamd-Server: rspam05
X-Stat-Signature: xcub74bi94r451i1qn3gxpgtzodo4hws
X-Rspam-User: 
X-HE-Tag: 1757460854-254784
X-HE-Meta: U2FsdGVkX1/qEZ8AfsADAM20jKmhLK+COPKDX30DjbUqJVwR10zfjrPOV+0qwQRP0eoScovwsjj+P1DfqSFvnMvvJh80hE89isWqngQudBf/C0fr6mKpwirfhohHL2yRxAvxCwHG/jqVUuGsRFo8HqrM744Ix5gyrEhf/H3yO2+79jHmYaBl8LjNRcHvZ4KRr1AUVXEoesyYFWroGEjUyGpV6XEmtsnI2iiwyBzcL2sk2ikeys8b3bOfiQzl1nTxFz94mVZ5/Igyfa68TaN4ToL6ZndhEtJDtsDWMIPI9xmqwNdvQsxJEbsBAwf0AcwEvyK31KjIJFSQjm4x5Qg3Nrjoo7O3rhVZq0kNKtUrQCbKTbNyzuC3ZOJbJ676l0sgqGZ2idOb48i/775Z239pH9Cv1IRQCRFOlx4z45Jr7h60UVaPhB/jlYjolC0WINPw7uIeyFqs5PflJjZdRcV6bqahJUwjOc8X/ojMKfahZeFkH8afueaiJlfaB8+zGnCBW8oc0qUmPndZOJuS9Xfexvfza1vva2DIlHWFm2LiWPTAFB24+0UQfkTJF0Ud7S5QdcJohwpqb4srUfIwizLhFY4JeV27567dv2P5q60MJafiaiiFmGUxBgWGJG02+XeKTfK4Cb5HNYjDLMy9fduyURFhKj6O2wTsjFURCcZlEgqULQXzLv7R8u4t1ngjnxji/IRRfaCmjpjlSPd8Hf7u/YySE8DSP97mihkX5/IFYtvnM7H0hkE+M4uFoefIhrNzg5etswqrWInM4jy/iCxkDDT4mvUuqCBt73gDmhjccRY7lYqGO9fHZU0u2pnNqEdyerXj4fALF8wZQE0MQfRQNjxlVDR4WciThdEkC85uFyZRJGTzvExUrTIvMghQCzilK1pJAkwjY1QWk7nKPAYVO+0MWTOfiVxHAs3q904YNnR86zTJklDKN6W19BzBVTSrOvBRDAwPK4kh3GKPoE2
 jSjfYsTC
 g+jm/eOAbUmA+MfLqfcd+0hZU5LcYOJHDhqG5CTeRk/uFj4VHmkD7t7LPBPLVR68JCO/C5+mutfYssLWkMT6eipbRldGsCRq7LIyIRX+y49Baqms1Nypf47G4jI8jIPA8RcBzNgamEZiXqUP05+vBGI5f8cAV7aK2d8mZu8J5irjz93a13Ili/Pi1SNtYmhn1goCaRjscwK6ZxCqM+azzM7ONMZKNM6BOBRorfAX3jryaCiVj0wVwF775chCgXryQvKP3pT8X2jXO4M+k0BoH2d6N7QH92mFDmJ27HUzemxGlxUSQsn9POva7bTKYIpzpiGmcMYgyYQUHwQrQgVIlOtp3ycNFNa1D+/SnVMvECM71Qq+22vgoWKtmKXFunnfgRWmneSM7rChp3QyZM4ICosMZ71MXzfL3QDIDa+nxe0qkdrnDBBr5/rmipoTyBKzX0E9xJkg+GV2hL1HFlAxIVsE1q4c56G9DWzLmcex4YYzlMqsMVtdnQnhphQG9G5cMKGLc/S0vCRTF9sFqz2l18n8/Hk6XYEGwsZ9YzouwBrzkSjxkqFnqVXu99ySsmWRFzdlCzAzW5aYU6HU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Over the last couple months I gathered a few reports of minor issues
in memory allocation profiling which are addressed in this patchset.

Patchset is based on mm-new.

Suren Baghdasaryan (3):
  alloc_tag: use release_pages() in the cleanup path
  alloc_tag: prevent enabling memory profiling if it was shut down
  alloc_tag: avoid warnings when freeing non-compound "tail" pages

 lib/alloc_tag.c | 17 ++++++++++++++---
 mm/page_alloc.c |  9 ++++++++-
 2 files changed, 22 insertions(+), 4 deletions(-)


base-commit: f4e8f46973fe0c0f579944a37e96ba9efbe00cca
-- 
2.51.0.384.g4c02a37b29-goog


