Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5AF8606A329
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 07:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CPZ/ip1l
Received: by kanga.kvack.org (Postfix)
	id 0597C6B05B2; Tue,  3 Nov 2026 02:59:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0098E6B05B3; Tue,  3 Nov 2026 02:59:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8AEC6B05B4; Tue,  3 Nov 2026 02:59:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C81906B05B2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 02:59:33 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 33A0C120303
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 07:59:33 +0000 (UTC)
X-FDA: 85393058226.23.6251E8C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 859CAC0006
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 07:59:31 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="CPZ/ip1l";
	spf=pass (imf10.hostedemail.com: domain of jolsa@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jolsa@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793692771;
	b=Lkf1TIJE2WEgms5gxckwbkFzOHtGdAq3A/mYYn123FRufIKo/EanHa9ituC4IJo1iB/5DE
	aHh0coogQB19U6rTQ/zyhfBQqJhfCevbgICtxtUymEHQLoGJHtM0q1J1wfkJ2VERA522BZ
	CigwFHzrP5VS5xTGCJ4Wr4ninVPzd64=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="CPZ/ip1l";
	spf=pass (imf10.hostedemail.com: domain of jolsa@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jolsa@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793692771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cUf6B2WQBT+lXoY0m25EQ2J3rZ4cWPkyKm+cBrHh3T8=;
	b=5eH2P7AU5lahlG9xJuA+dU9e96HzWOIqpTZqbqSzsfx/wr3hqpS+Q4YEO3ynpCmsEc/iW/
	x2CJ90xGmsCuj9I71ueqZaL3U4oN1JTTYozzq6Pj9lfnRHl0QJz88m6ahMJUWbUp5MyAbP
	AzA7uZwXFWSqM/8AaRxOk3jG9dgwJ0w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BF7A443BE4;
	Tue,  3 Nov 2026 07:59:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 204E91F0093A;
	Tue,  3 Nov 2026 07:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793692770;
	bh=cUf6B2WQBT+lXoY0m25EQ2J3rZ4cWPkyKm+cBrHh3T8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CPZ/ip1lhzJFLM+8RWjyEPfV7rdK11FuXBSJ2QXCeuMIyOntG76LCmW3KSZdy4Hvm
	 yUIM7KO/V0F/8dKMy29K4kYfOODoG2lwVggbZ6S9jSU46/UxEIBYX7o0NeyNEqmLc6
	 1GXCBjRuohC69wTw/Q0hPoBaZEK+vKYTgpD9WSRJQTEAps6hUiNx5TqBfWQQJlisSD
	 o7nqJ5H+sfx/8Eaf5xQzDVC28tsS/KBnSZ1poTGcpFev1Hsh1PgTjQBjiePPLURuxX
	 k7DC2Xxz8myb5y/EMHDxbgKt7ao2qkjzote+eFCgw7OGPdRG4dWZc+jTjHuffMNJLi
	 +GJQ8U2xRqMsQ==
From: Jiri Olsa <jolsa@kernel.org>
To: Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Federico Di Pierro <nierro92@gmail.com>
Subject: [PATCHv2 bpf-next 1/8] bpf: Honor const on generic kfunc memory arguments
Date: Tue,  3 Nov 2026 08:59:08 +0100
Message-ID: <20261103075916.100050-2-jolsa@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261103075916.100050-1-jolsa@kernel.org>
References: <20261103075916.100050-1-jolsa@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: j7x3z4mf6yf66ihsjocb1x5wucoe9r4g
X-Rspamd-Queue-Id: 859CAC0006
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793692771-620309
X-HE-Meta: U2FsdGVkX1/HkpyU7xdB/C4v7cIpJOYdzBzb5/H724xas2VDFS46ugz3YNCFMJ08Jz7oNV4/ur5Wxz55GndschcvccVw6z+iPzrjhsobtV/tQmBpbIpwDJDepY5nVM+TK0n5/dLUUPRx0CqnRz1TI6iL1/kBWz82TuetYG9ABxPcAKmuA0SduziQtRNBxtn96ACysyJCPWQyaVI4CoBH1BQTMUnmdzaShaEp8bWEeubiWO6zZlFYjoyEDNlHLRUhYlCl+puJMhqdzny9RblqErKdx0b3khhOq3DA3m/RV7F1vVU4C/yyBLlo5NLaLKWK9WRUTeSR9bm7zTlDd686BaCshG7qcXz57+YCNmSwWaX/DzZEbbGksz69dsANFvhQSrYrzCkTJXhONgdPVqjZDe8BBo3QWLRlhLX5PofUaEJuDwT4iYZIJxb8y5W89UB5KNqpMIBp2gW7s3ZVJPHQ8vkl//gvGzsJGAKmPdnP6IgJbULIqjDDWiF1hD+1wdCsV27dXJqxe3cfNnE8rI/bqa3HRyghRFe56+nO9X/Y/7o7ar4YsJxJY0V8DcdWA0DoFrHomkoaLZDeNan+1bTos2iU3whKIzljqEd6EXcYXTwjPGPllmBQIuK5p58Zy3ys10OblLZMvLSxkhnVhMktZCYb2elrYE774M+h1T5yPCOzFC3RuJ/PlklWvGu4FcAe0JbUiZ723mHaS1k9VxXPMdplMQYaw9O8jchWaIXaayIh73SR32YbNf1N3jTAeUxFl/3Y7Mg34o3M0QowjwQJhqWPAqkwV89Uqy505litf0QvIb3Ntoi+LIlekdaqxUvo+7MNCYOQUkUKuoROOENafpv7NcZgWeUTtO2oux+NF5obnxAzdeVnHNinxwiKY3H2iwX2RGeQg9k97qmfJX1yEV440ZaqC1n97Kb+208UKm03kpiT7g0QJfd081WrTg+pycsRJIqI21wpq2UmEDk
 +YWXVaih
 JfPZ2TsqP8KNcCiSicQmHUiD1DEAsft3HME0n9DTXxIOwMdvSpbTjCRDxbzbxTQz8Pm6cgCKG7KU0dCdDnj9BCzz7LZozJyGb8PNfHXKYe5PxcdjnOloguXzBWdXkhMw7llbCKO8+C13BF8V5pgYGBzytI52M947IWsvv2vDTblqCC0ANQ41J0WNIoh9436W107PM9jo8ltzXgIEv2kJo+nLP2y7HDXKU+8CMJ+stFq2EV9E0YhXX5mAmbT/FAdNZEoYwOEc4f3fwnEjcWxGLwdKGGAovVf8YC2hTnnj04WXYjowCVb0CS9RSfA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Mark generic kfunc memory arguments as read-only when their BTF pointer
type points to const data. Preserve that access mode when resolving
scalar structs to fixed-size memory.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/bpf/verifier.c | 38 +++++++++++++++++++++++++++++++++++---
 1 file changed, 35 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 935b163f81e4..5bc637a6fb13 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -13182,6 +13182,38 @@ static bool is_kfunc_arg_const_mem_size(const struct btf *btf,
 	return btf_param_match_suffix(btf, arg, "__szk");
 }
 
+static bool is_kfunc_arg_const_ptr(const struct btf *btf,
+				   const struct btf_param *arg)
+{
+	const struct btf_type *t;
+
+	t = btf_type_skip_modifiers(btf, arg->type, NULL);
+	if (!btf_type_is_ptr(t))
+		return false;
+
+	t = btf_type_by_id(btf, t->type);
+	while (t) {
+		switch (BTF_INFO_KIND(t->info)) {
+		case BTF_KIND_CONST:
+			return true;
+		case BTF_KIND_VOLATILE:
+		case BTF_KIND_RESTRICT:
+		case BTF_KIND_TYPEDEF:
+		case BTF_KIND_TYPE_TAG:
+			t = btf_type_by_id(btf, t->type);
+			break;
+		default:
+			return false;
+		}
+	}
+	return false;
+}
+
+static int kfunc_mem_prot(const struct btf *btf, const struct btf_param *arg)
+{
+	return is_kfunc_arg_const_ptr(btf, arg) ? MEM_RDONLY : MEM_WRITE;
+}
+
 static bool is_kfunc_arg_constant(const struct btf *btf, const struct btf_param *arg)
 {
 	return btf_param_match_suffix(btf, arg, "__k");
@@ -13550,7 +13582,7 @@ static int resolve_func_arg_type(struct bpf_verifier_env *env,
 			PTR_ERR(resolve_ret));
 		return -EINVAL;
 	}
-	*arg_type = ARG_PTR_TO_MEM | MEM_FIXED_SIZE | MEM_WRITE |
+	*arg_type = ARG_PTR_TO_MEM | MEM_FIXED_SIZE | kfunc_mem_prot(meta->btf, &args[arg]) |
 		    (*arg_type & (PTR_MAYBE_NULL | MEM_UNINIT));
 
 	return 0;
@@ -14102,7 +14134,7 @@ get_kfunc_arg_type(struct bpf_verifier_env *env, struct bpf_call_arg_meta *meta,
 				reg_arg_name(env, argno), btf_type_str(ref_t), ref_tname);
 			return -EINVAL;
 		}
-		arg_type = ARG_PTR_TO_MEM | MEM_WRITE;
+		arg_type = ARG_PTR_TO_MEM | kfunc_mem_prot(meta->btf, &args[arg]);
 	} else if (btf_type_is_struct(ref_t))
 		/* A pointer to a struct without a size argument is classified as ARG_PTR_TO_BTF_ID */
 		arg_type = ARG_PTR_TO_BTF_ID;
@@ -14127,7 +14159,7 @@ get_kfunc_arg_type(struct bpf_verifier_env *env, struct bpf_call_arg_meta *meta,
 			return -EINVAL;
 		}
 		proto->arg_size[arg] = type_size;
-		arg_type = ARG_PTR_TO_MEM | MEM_FIXED_SIZE | MEM_WRITE;
+		arg_type = ARG_PTR_TO_MEM | MEM_FIXED_SIZE | kfunc_mem_prot(meta->btf, &args[arg]);
 	}
 
 	if (is_kfunc_arg_uninit(meta->btf, &args[arg]))
-- 
2.43.0


