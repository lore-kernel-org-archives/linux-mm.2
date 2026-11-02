Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D92A60E6039
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=XH1Fqx2i
Received: by kanga.kvack.org (Postfix)
	id EA5506B0622; Mon,  2 Nov 2026 10:37:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2E9C6B0643; Mon,  2 Nov 2026 10:37:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA8E96B0645; Mon,  2 Nov 2026 10:37:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A55F46B0643
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:37:06 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3E9E8120151
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:37:06 +0000 (UTC)
X-FDA: 85390582452.04.2F9A502
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by imf18.hostedemail.com (Postfix) with ESMTP id 86E8B1C0008
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:37:04 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=XH1Fqx2i;
	spf=pass (imf18.hostedemail.com: domain of 3H67oagcKCHw0nunsxmlttlqj.htrqnsz2-rrp0fhp.twl@flex--vipinsh.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3H67oagcKCHw0nunsxmlttlqj.htrqnsz2-rrp0fhp.twl@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633824;
	b=pTYa5xJfMeqUqbyJu+cH5qtcuJhJlVat4/eEKkZnbpXa3OLa4iflM3ALjR0NDHamUc2ViT
	6X/783QcRbVnnbZ78OnotEnT6YoSykVlV4ksR21uIWqyKpHZGOjh+p2YxlRLAmqRS382fu
	Yz0ByDSrH5P1GioskddKoliLPzjBO84=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=XH1Fqx2i;
	spf=pass (imf18.hostedemail.com: domain of 3H67oagcKCHw0nunsxmlttlqj.htrqnsz2-rrp0fhp.twl@flex--vipinsh.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3H67oagcKCHw0nunsxmlttlqj.htrqnsz2-rrp0fhp.twl@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zTFnRhvBDyUF5JRAjEQ7l0v+FU3UL1Jli3F24C62wAY=;
	b=wLkIiLtH60xGZ9nnIT5lfaNoJNXToZk3IKuCYRvnJWq2VHPaGs2eVPl8yU38pZ9wl8yzKD
	1zgCccb34lulseJD/kkQ+T6c77UY/oZ8edQ6zqxNmqZlWjtI49fj5spDQq4gPNTRxFOmcE
	04zlWk3/52j0/zA4+rYgsFDhhuKVQv4=
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2e9572e892dso22551855ad.1
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 07:37:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793633823; x=1794238623; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zTFnRhvBDyUF5JRAjEQ7l0v+FU3UL1Jli3F24C62wAY=;
        b=XH1Fqx2iPPrEuRN3KXDZBaAZRwPRbej+9bRjGPj+AdDeJe+bXszpPXAcBmnGevo3tJ
         7Wc2Kx2VbjBLWovtgVGB3RhRdHjuS9ICOaFIMUf3rgiIsBSk8ClluXDGQiOkFLfRmZCf
         bPSRGKnYz+CC7SSx6zvqq+qLrH0O1Y7huMt8LRtuqd+eYTs33a+BV1T2K2I79l0jOhSU
         xwJ/Rslenl0WHCAnmpXdhV6U3Q6hiWI0tFJyDiY2EQR1R2TjMgD2WJEhaOzOAs0XbA19
         2RyAkDOaXi4BjtRI4JzUWU6Vn/Q0EW0IhdM6pigJyhR+cZWkKMa36XxENLtsaAPzqm2F
         QDvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793633823; x=1794238623;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zTFnRhvBDyUF5JRAjEQ7l0v+FU3UL1Jli3F24C62wAY=;
        b=2Nab1orr2KOdFnQWYC9Gl2mqf6cMiAAuuEM/PLkUfHUQMwZ7JBQT9BHwg5lR+hC5UW
         hx9peYPxFKtv9S3IwfV54rp83d6zoKsM763YBx7czcasRCcIXePCvPzwxghNgh52Uy2w
         jKIN8t6vY8naMBqyUujv9J8nw6Fu++zxF9OYrn+nZ/r1OdV8UZwv2FrSgxdEmQXobo/i
         Um701xD3mMch+IY4IMroldCyWgX6QKGUjTRJEf1g6tZNfP+Ado0c0+qYgPaQvB9D4rir
         881ACLD5XGdJ7Wd/bl8kdNmnYUoxDz62jfTwTf5mOSBO3IPLoI/lZXh23wlzNFGD+1ZT
         3NzA==
X-Forwarded-Encrypted: i=1; AKwUvBwlPcO8sllii4xg39kvmI1vaT45vKGaBwm9h+M3Pa3aCH785tXzdA38lX0WyKYLQp2Yad53hya2KQ==@kvack.org
X-Gm-Message-State: APuU4Z8VByKCd3J1nfVn++7ceiPkFjsGZOB1aIzLZ7/RbmQVV4qG6Owl
	L8PfXCxhiseKV8QTjyrQg5y+QacU6nlSYisElCywOjmjmmGsw/RPZFN2mi3Ip+Yd1TzmhWWbpMg
	5CiL0mQUBvQ==
X-Received: from plar18.prod.google.com ([2002:a17:902:c7d2:b0:2e4:8c0e:97db])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ce0e:b0:2e2:fc90:11a4
 with SMTP id d9443c01a7336-2eb364faec7mr97592545ad.48.1793633823158; Mon, 02
 Nov 2026 07:37:03 -0800 (PST)
Date: Mon,  2 Nov 2026 07:36:32 -0800
In-Reply-To: <20261102153656.1431701-1-vipinsh@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261102153656.1431701-1-vipinsh@google.com>
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
Message-ID: <20261102153656.1431701-4-vipinsh@google.com>
Subject: [PATCH v6 03/27] liveupdate: Export symbols needed by modules
From: Vipin Sharma <vipinsh@google.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-pci@vger.kernel.org
Cc: ajayachandra@nvidia.com, alex@shazbot.org, amastro@fb.com, 
	ankita@nvidia.com, apopple@nvidia.com, bhelgaas@google.com, chrisl@kernel.org, 
	christian.koenig@amd.com, corbet@lwn.net, dmatlack@google.com, 
	graf@amazon.com, jacob.pan@linux.microsoft.com, jgg@nvidia.com, jgg@ziepe.ca, 
	jrhilke@google.com, julianr@linux.ibm.com, kees@kernel.org, 
	kevin.tian@intel.com, leon@kernel.org, leonro@nvidia.com, lukas@wunner.de, 
	mattev@meta.com, michal.winiarski@intel.com, parav@nvidia.com, 
	pasha.tatashin@soleen.com, praan@google.com, pratyush@kernel.org, 
	rananta@google.com, rdunlap@infradead.org, rientjes@google.com, 
	rodrigo.vivi@intel.com, rppt@kernel.org, saeedm@nvidia.com, 
	schnelle@linux.ibm.com, skhan@linuxfoundation.org, skhawaja@google.com, 
	vipinsh@google.com, vivek.kasireddy@intel.com, witu@nvidia.com, 
	yanjun.zhu@linux.dev, yi.l.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 86E8B1C0008
X-Stat-Signature: uoq343o3i15ja3akpb4hwskby8zqobd7
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793633824-203673
X-HE-Meta: U2FsdGVkX1/bDhjrriCvVQ/liLxqX9z4RQ20gBcdnxeNRJe8xXLMH+lSykOv2JENDTIWUByRhicueOw7pLwuiAsOOUePmdQ1rJ7lLU57xNXe19TpNXW8gq6pghK1JFVL62RLYowGH7amBZQB7fOE5mPGkQdFJ4h5hCKDM2VUoyZ4GjESSUaIhBx2zoJG/5LQrGfVkz+nQuzZIxYCw9iueHP6l68O8+Pbg/vJO3uzwtnkvOJ0k0MKiDtXHnx7AvHj+Jhf+/eHNWKpnfmk171ZgW5na1vwWCO3i+gCDX7iBpaVYnEmH4OTejI5huOABqmgFK0uq5XKSYiAzHUp6OVq9k6F+FFbdylyvmo0nG9cAwXrsezjugY5GDdCMj5Iz9w1jIHSyoPN14qyAXhwTtCg0gBu7BhI+srdVkhsmon4mkezczSZYJSX2s8dCUlcaZU4jR5MR0qPmDiyF52O4/rQ+ZWimGSWQYOvrWxEPzGMNmyl083SJ0mRr9dgNlI6HM1ZWOW4xqWmHIvT2y1kgef5y54w51vr3r2WP28xN1QK6B++klTjlTd72qU3w4clCRXMQVuO9GlJdzqS/qeCSllRiTooWIfrwj7VQ+lyTuYXYax0wNb05dCjWOnppws6EXBLlC6yHPQSyjaJ2HzSnaIGTO3cEg+EoMTkYVg9vbbk2O5NHAz8pMrkgTM4fW9Y3rM6EVzIQ/YI67ZE5z3B7/t8pYQQSosWdKLfhwp0QnwwreJWk9EFfjFPg8fiWKjHrx1gGmJ49qOydlxEsyFASZx+QhLNSh+9W67cGqGsq+ghKeJnY9UrFhWrzW60BPZhI75nbYROV+U0pMF1jS+YPeQhhbAXYGAlZ5rbFjMQcXc4tJWk976dh0vguWalbf8+yhrBYwBBniLHWBjmf3Hju39i4VH5trzVg7I3eNRvgA1C35xQ7/IGPkkqiM+me3RnMjkYWKJo2bBLcPLfWHhTzXi
 EVVVUNfy
 5kdD8yD9+NPkaao9m0xepcm2DVJ+ryfewDVC6h51ZKyGYxHTcPboVb87k1ThwpBug2iel4XW2KdYzPO+nfzNjIJ22T/bB0Lj3ttQHqbZg92k3HCup5NyzzmAC+SIbI97Wn+E0Wech1FRkNJA7gEJNqClIW3gWZXOsyI9F8PNivghU8MlwNVNJNrqtvK/VhWoaswkFzI0ms6ngX4mMqYQCrD5GCsIMBR5dE9N6XbTLV8P5xAKumd18qCtim7+UCjASpvz+5XI9af1Sz5dZbTEm8fSoOytHanm2OE5HLaaTbfEHU6iLMje3gpUYqCs4npVJ4hQq/7ybhNnN6xwj1oXpTF0skXn9q6Ui4N6CNaHuljkbQGmow/rBba9nnl37pLkkopkCEtY6ZDukX0L6M2dSSMlEWpwLT+i0R1ofsvV6Ia7f1LsUPTKHJSKDEPjDxfjws3ySGtPEvag4gCJXe97PEOHxZUS21rVNhxpOoPEmkrnznFBAyk1lsDpu1TCTS3lsdOERQFMMyORPyV4oAwXdm/WAOlocD9sMSwMbQv1Hw1YmHw8LLZhp5LTfNcCKOgQ8WvGSxzSneHAw/Ai3zwUllpsPmxFSdJLRrbc2Dawk+zKR4mcl//wmSdfuCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Export liveupdate_register_file_handler() and
liveupdate_unregister_file_handler(). All of these will be used by
vfio-pci in a subsequent commit, which can be built as a module.

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 kernel/liveupdate/luo_file.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index dbae0715220b..6aaa9a531428 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -916,6 +916,7 @@ int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
 	up_write(&luo_register_rwlock);
 	return err;
 }
+EXPORT_SYMBOL_GPL(liveupdate_register_file_handler);
 
 /**
  * liveupdate_unregister_file_handler - Unregister a liveupdate file handler
@@ -933,6 +934,7 @@ void liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 	luo_flb_unregister_all(fh);
 	list_del(&ACCESS_PRIVATE(fh, list));
 }
+EXPORT_SYMBOL_GPL(liveupdate_unregister_file_handler);
 
 /**
  * liveupdate_get_token_outgoing - Get the token for a preserved file.
-- 
2.56.0.317.g454f8302e1-goog


