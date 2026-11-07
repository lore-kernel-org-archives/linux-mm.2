Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CA0A606A800
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HHW04eun
Received: by kanga.kvack.org (Postfix)
	id 035656B05EA; Fri,  6 Nov 2026 19:37:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED8496B05E7; Fri,  6 Nov 2026 19:37:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC7706B05E9; Fri,  6 Nov 2026 19:37:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 948386B05E6
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:16 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 33AEA40288
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:16 +0000 (UTC)
X-FDA: 85406458872.09.1C7F127
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1C48A2000A
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HHW04eun;
	spf=pass (imf03.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011834;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ttx/3hBeE8lksy2FGsNe5d3QOJT7B6jPkU8kfvGYtR0=;
	b=AuY0FDv8RsM/d9WhKsLNk5MP/QZ3eir/axqOJJDBPXr4dhY2hBepmQwvqeJyHD3byWbw8W
	bZHxAYsJTCISPq/yQPQ1IyNmwiNxpOpPmo8D2pT3OYSydWnFb0QdckJP6Ds7F/vcqmGDe7
	hoZraT7D2lSzqbPSmUXOADuHlTTHvns=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HHW04eun;
	spf=pass (imf03.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011834;
	b=6FcGIdsDYmo8MO8HyAEjISb3WBaekWle9yCa9kdcQHraxkAz6sA5X4GfwbG4Egq/r6u2Dm
	fqQpVtbiq1yi5FAYi8GzFq3aL5kPlQMQy6zLg83o7D739KUglSDkcfMNzm2c+BsEy++Zdj
	tnXXbOjZHcrDZrndACO8+A1OsSnKDMI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DFAE84402E;
	Sat,  7 Nov 2026 00:37:13 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011833;
	b=iXhcGqspd84qIcGG4hgIzBzwygszoI5mxwNS1oOQUoXjwnM4P8kiK2AVaYyE6rF06umQ
	 i4S2f4A0Vapa4+6XfANaiOVjUBLkUD4eE3CNf8zovYu9zWsbw4x/WGJfvgivYIez8MqSp
	 6orFbrK4VZkeV8LEVOu2o04S9bnN/locc2K/fZUxLj0zh5jr49ZvolefYBgZE69oTOa+U
	 H3CGe7gP9ozwpj2Z94A3ShbJ8r5YA0SkZwctW5kPvAQY0c8Jc2Sa5IOSUX6XeSaGxueaC
	 Q9x+IgYeYRe8G2LE19gM+e8ww411n3NriiSzCyko0I3TISFjFEQTIWoOwOjL7hKvIhA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011833;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=ttx/3hBeE8lksy2FGsNe5d3QOJT7B6jPkU8kfvGYtR0=;
	b=YwiOYJovE4HtCnqYs1KPCtjrvIC3xuAE8Z2jqSRtAP8VNlfZq5JaZ6HJbAMWvi4qdC4r
	 FG97H9QTU4ieLSZFrf5+emrWtzZMzMiSKJ9SfNvK+V3kYfr+sUL1p6702CqfS4OqJgWUM
	 fnAvBYeMwpSYqQbTPlAHXNDi8JPpYQd7iNI5cLl+qPEoJvjHyTRK8pV2zpbQbyxnlNOEk
	 S/qIL0sHbGGPIVM8055XYN3AZeV76yo7Qq8ndTO2AZsbA3lU8sXQz+QCXGVG4/8D8bR+9
	 v6t/5ZN9DSsViY32mHO/w0zBvMw/Pgtk3GRp+VX/88b12iVQlgvzptDRj9yPaOvnr1Q==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id A36551F00AD6;
	Sat,  7 Nov 2026 00:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011833;
	bh=ttx/3hBeE8lksy2FGsNe5d3QOJT7B6jPkU8kfvGYtR0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=HHW04eunuqjPqIEBmg4cgYT2MQ3D4nbkYA3KPz/7EfS3w3mRbMwseGnvbghUSl5b2
	 9AR+rDgTqI6lJpJ4YZJ0o24wMvvM+qEzJhYoMCwdGBGa7SI295+sBYu4fgmplG/YKg
	 s0EFKc3J8OsBUAi8HfDQUlXFQDPIKcQpGJiV7gD9Vnf5GX2G8U0QEajQVP20z3Aq/s
	 CK8OhTsMz5h4KQ9NjWzIiMXVhn/iOrC7iv2ZZ+aQzQg6krCGMY3jSvi01efeyqm+Ha
	 Er1gj/KySXQrhGTAJR3u7n67MxEx7oTgN6yQIVPofV7I6HPlnwmVOcl5rGSdYpc5c2
	 kBYaL65tIpehw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 069AA479C4;
	Sat,  7 Nov 2026 00:36:56 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:19 -0800
Subject: [PATCH RFC v3 45/88] samples/kvm: Disallow MP_SET_READONLY after
 attach
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-45-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
In-Reply-To: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
To: Alexey Kardashevskiy <aik@amd.com>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Christian Brauner <brauner@kernel.org>, 
 David Hildenbrand <david@kernel.org>, David Woodhouse <dwmw2@infradead.org>, 
 Fred Griffoul <fgriffo@amazon.co.uk>, 
 Jacob Pan <jacob.pan@linux.microsoft.com>, Jianxiong Gao <jxgao@google.com>, 
 John Starks <John.Starks@microsoft.com>, 
 Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Sean Christopherson <seanjc@google.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Tarun Sahu <tarunsahu@google.com>, Vishal Annapurve <vannapurve@google.com>, 
 Xu Yilun <yilun.xu@linux.intel.com>, Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011810; l=1622;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=W6hpgZ/SuWeulozFQ+D1CrfcagL7NIynEtQGb/opNZw=;
 b=ILyPeR8Z4qzwmTsH228I3CTu1pFhQQ5MWMIByYFJpNmOGFiP/sRffFefkPZJvJJmQLFRCWCMe
 r5kLMeQnZa7CLlcRG/TOCMgsnzmWL3Yhl8aE192+9z9TDbTji6SwO+6
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Stat-Signature: nox4e3gq54xnu5aonaoz7omwo4zhatcq
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 1C48A2000A
X-HE-Tag: 1794011834-46603
X-HE-Meta: U2FsdGVkX1/VeJ0yhmRXqs/S2UEPBQ+FovFcuhE0ardZlWDmDLRAdkhPqw7OuiXtAtL2xoznFgf6TSmOQgxJ1E3K+wV/HUyRdc3VElo3aDQXqjssfa5IjQYGZr1dY/6SYy1+yaoDSrTwuc+koaVaWYpTNAy3XeD+ZiRVkWqjADjK6zBP8JQk1fexDVtVZRJ7nopymqnrH+4sT68P04FwTE5Ld0K5JS6L6f94TUi8LG+rYhvG6PwqXuFmC+6EVvD9+KuWbVdNGkbpAuoSiWQ+F8iUROcRS8TgMlkznOgsWXyO9xzpH6nb3epWDj8HtLrFG5ZUzdiN0pcl9kkTJ86E/UfKV8ltN0qcS0SqFdzNl/LZ74qincC76MQdXlmJXpjJH1Utm++FIkxwb/4suIXRLkBU7aFPsH7koBWbH2LK62BFGQs8O2s+57Dq82ELx0HzlebpHO39Zub0aD5Ss2uGSSM1FeWOkalu/Wk4RpIAoD++4FzNsE1+wYlxgvgQ7PwKi3MDEw4O9L/MhldQdwnBiwyO51gM38fNmnYdL+xRWV+W0LdOIjI4cmSDYwni/r5oEwz6SIuT4wg0EEc6KDWuFzRQJQsZQXhkq09z9VIFaM7qC2Zsc06ORmPhdeQnLdf+pM+BSQ/p4cEGYqRf2k8MP0QThQdVJpwCh4XZ76Q5G+yhDyGr04bM015dUP+9qhNeXdIlAvemVX8jzjRNui01i9P8K9m7Fh8fHAek6zP+lPXmsYLsaedtiKqpogT9bQ+OiK4Twnm7AU3Z5+y0tDrVlTgWm1o2uWOoco7ZRf3NJMahY16HosBKTEvOjwGg8TmT/2goFx33MjHUj0q1Kj/5E4kAhnJ7qSPgPvFGBEyWLZKRhYfMqQH0xjZ0HTRPU5Q0LIjkgqFUX3Qrwe272UYRfaeWCd0hQSupU6GgllVRtpY4PHzGqneoHrq679RC4Rz36XFtot7kYC3qSLqWqWC
 uMUx5pYC
 zEwrN9DTFmiKeAdJbnlUaTpC/YmxewrTSSVLZFiC1mJS0rAO2Ey5nlu2YnZ3konpunKHL02Otoa/dZOTMlPbCDcsEEa0rpU9DcFb8nw20t5SuR6GYwIPz6LPWzFMcOyCF7fk6jsyoQMBltHBxth3Z9gW1ygyacz0IgwqSugI8v2FUO0wQkZsmqXDv7xmBBxwCn+wEyiPeUqMBDYTwGqQ/YEj8DYSg9YG563in04Q5DMphfo8yDiqrdSPO3lh9ba+FwLV0XYED+tsM9IQnN97aHevVCe3wo0hcDww+zzG4de7cspOg+abpWfRS5zs/YFlSDfLVCAEcS08+mpS/WQDJGoa3sNzTiEVkg+VZL6zsY2VHTsuqI/Q/KEestd3f+SIfVG9ZE2D2kMx5UqP/+f83Y8lajeBABYotOyk3iF64PFfvd8DmkYeBReXK6VgR5oJv8kWe7/wPBwEP9dS/mcFHtVoW0NdWUFu+mJLTF/saKAjX+0J+4WYW0baai4v7fJntNfjYuZoStDTIJYSc0mQuObrY7x/zZCq24drMCMXkwhURXPDvz0xmXk3EJGG2+t4EZq5agE9+4UZ/k4IbJ9xRuEZoVrwbI5ftr1lHANOHtXjb9oA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Once a provider file is attached to guest_memfd, its physical attributes
must remain constant throughout its lifetime.

Disallow changing page read-only state via MP_SET_READONLY if the provider
file is currently attached to a guest_memfd inode, returning -EBUSY.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 samples/kvm/memory_provider.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/samples/kvm/memory_provider.c b/samples/kvm/memory_provider.c
index 6f86e3e3262e3..168c1d90edacd 100644
--- a/samples/kvm/memory_provider.c
+++ b/samples/kvm/memory_provider.c
@@ -58,17 +58,23 @@ static int mp_range(struct mp_info *info, u64 offset, u64 len,
 	return 0;
 }
 
-static void mp_set_readonly(struct mp_info *info, unsigned long start,
+static int mp_set_readonly(struct mp_info *info, unsigned long start,
 			    unsigned long end, bool readonly)
 {
 	mutex_lock(&info->lock);
 
+	if (info->gmem_inode) {
+		mutex_unlock(&info->lock);
+		return -EBUSY;
+	}
+
 	if (readonly)
 		bitmap_set(info->readonly, start, end - start);
 	else
 		bitmap_clear(info->readonly, start, end - start);
 
 	mutex_unlock(&info->lock);
+	return 0;
 }
 
 static void mp_set_present(struct mp_info *info, unsigned long start,
@@ -123,7 +129,7 @@ static long mp_file_set_readonly(struct mp_info *info, void __user *uarg)
 
 	ret = mp_range(info, sr.offset, sr.len, &start, &end);
 	if (!ret)
-		mp_set_readonly(info, start, end, sr.value);
+		ret = mp_set_readonly(info, start, end, sr.value);
 
 	return ret;
 }

-- 
2.56.0.455.g6c5a503b38-goog



