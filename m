Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE057606A321
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 14:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nD7cRy+X
Received: by kanga.kvack.org (Postfix)
	id 0B4C46B05B4; Tue, 10 Nov 2026 09:24:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0647D6B05B5; Tue, 10 Nov 2026 09:24:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE3E86B05B6; Tue, 10 Nov 2026 09:24:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D12056B05B4
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:24:50 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7898AA0925
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:24:50 +0000 (UTC)
X-FDA: 85419430740.16.F671837
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id D57AAA000C
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:24:48 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nD7cRy+X;
	spf=pass (imf15.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794320688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wS0G4PKOC+sZAy6EBQh5wk5dk7w9XV8dQM2PrsOePY4=;
	b=sEk25Fvy0JylpiY590NF0Dmz70YuuKTXmJGG7uZwvmCi8m7S2/ACi3D9Xn85U/yfmxGnZ9
	bb+O8VjWbFc1n/pnc1YRMx4iG/XvngE8/rkThA3wC/lm/V1vIOs5A3C1FlCZ9ZjdIHpfXC
	aeptkMDI/gm0lJNDpjpuk3oc/GPDnz8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794320689;
	b=fqeDRWzTr6ukT2reDZdCKHe8S6V1aBKyjr+GYjHfEQmnN4A9JH9guNxG56Io1q/5ZfE03A
	DYirOfJgv+grxJetTAp/dDBCtE5S01nRnu6AhxN6D0N1EkTlbcrVT1u5X7peNiFQCVD43+
	FkAquYWpQHkxCN37rSmmL6vp2MPxdro=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nD7cRy+X;
	spf=pass (imf15.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9E9146323B;
	Tue, 10 Nov 2026 14:24:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C28711F008A1;
	Tue, 10 Nov 2026 14:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794320687;
	bh=wS0G4PKOC+sZAy6EBQh5wk5dk7w9XV8dQM2PrsOePY4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nD7cRy+X0568qFu8nUcq6JPrvPOJVhYUKp+avz+0J42anE6gpzVlqiUeSK6aozltW
	 RXRemI/pgDGuJXvkWk0vgMLHL80NRFZXf/JcwMuK6HviQhrU7Svp5Hhz6cPqVYWt9k
	 RRPlmy7863npcCz/OJPNh9cRphmve/iiaQWhepVCKT+krHfgQuXgwyzqMKWEQGtvgD
	 nwq0vQahadGw5udecF/tOEUcq+6691mzuuekKrBnF2LAaKfJc2Gjzsavf+roBL0X7j
	 amsceKqUsw3QIvzEXiD8CvdvXsr2xVdXh42N1rycfOtgnGzwV1JWa9amCdFtLHzdF+
	 lUp//15v6v8Qg==
Date: Tue, 10 Nov 2026 15:24:45 +0100
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	Conor Dooley <conor@kernel.org>, Damien Le Moal <dlemoal@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, kasan-dev@googlegroups.com
Subject: Re: [PATCH v3 09/10] mm, slab: add slab_tiny boot param
Message-ID: <avMo-x1-lj2YU2rZ@thinkstation>
References: <20261105-slub_tiny_rework-v3-0-0484ce59eabb@kernel.org>
 <20261105-slub_tiny_rework-v3-9-0484ce59eabb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105-slub_tiny_rework-v3-9-0484ce59eabb@kernel.org>
X-Rspamd-Server: rspam06
X-Stat-Signature: me31g6pm5jq33f7auqp6zf6igxiri5qi
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: D57AAA000C
X-Rspam-User: 
X-HE-Tag: 1794320688-81291
X-HE-Meta: U2FsdGVkX1/gx5EGmebJKgvgfHslV/JAR1fzctDLbilRhbSwF8mkV+yOBOu+DfXCFTU1bOJkJVCOalvwMknfTI+hBLrKox+dVa+yMVSJdq2F9PMcHSWUd14pCJ5qkW4fQNv1UGasUXvFrGHPW4e9yevylotD96FH1yu4/4+t4N0TwzRroJYbR+TyJZR+p7pncss0Ey2uubtdftav+MWBFR/0RbohBiDtF88CjRPMCmQ76s+A5R4hVfCS4rZ/PhZK+UhHfNowyi2Tn7W5tYl6IoTswbxPD+WfQW3fz4CDVNjuY+p8RLEgk/PQ0ecKFBMfFXI59S1Ajh3bl8WYpu2k1FAuGgoVS/FrY+5nTA+2V6r7I8Lw8OwKxPKKLrDn1ykS/OTt98dOs8SajgPm2QpVSCv7FvnOgFvqxbyPlcsBXr+zxHzPqlTamtHKYDGLKRdGbq0VFOvF75hckrQlGTnH1mCBZFZhv4q5TT4d+AKzt9xpFNjyIlinQeXi0rjGcujr1r5ngBUsblm14XuSTk5BJMi+zmRaJL2lSl1Oi/AC4B/4gZQTfTLe9zDMBQ+p/1f0k9LAdtSzkuQ/vNlvL7t2MhUzLfIXpSK7NZGg5i1fSq7oaumod4XNuYiIzAVw72QaTmf2DTP9Ahpk52fSNUr9Gzj6hzStEQVIXsGoDLyrZ4eyB9lqRjZEPWT0ScTaM0e2RaQZhGYnwENSaRhwmPSayKPwWQOrienHT1rShZWnIr3QtW6q9rw6HDWcVSrrIPtg0xcCI+R2aFDzCxfpivawSm2OFUdBQ8OwulduhzjbGOBD2yP1aOnbC3qqf2UOzJG4YBi0Z90jSHtvxAOf2uvTGJJY9PAJylw9AiGZcujRC8UoSq9t/fPNfTMDnACsmrowaVvEoGwcGpKroK0p9X4abVMgl5K5GJHWq8+dZKvRa/+v889WPDZPv+lICtRC8ojsC8FrVWeR2uqCGIS8eqz
 cXvDukcV
 1cfG6XMpUdxDBIo8kj7rHcgHB1oLIUVPIOQb4kqHOpXBngeJ/1N9K3IEzo+6aAknNv/cqKpFnxdtez5xyEsrDRSwhHYzkTDVrlePlfaOUNA2tZ7q/eyGz8JPOjTlC94AwFVdPnu4wBz421htz50Q9L3hWQcCaE8PgH1puGecLNDitlJrvG5y/ysrHw+TxdSDRBhx9fgr+UqwdYRU3DDt4KTlirtFE+uVYo0X2qOP8+U69Ft+uR2g00GdjSnuIH9HHsoHWRnyOf0Cx9Bll80n3iszWk+U+f79AjZucSPzyZxmpvhd0Yeyaqx1CB+nZp0XKX9dqsvuqTUjc4DIwdQKOBeSMll7b6xCyR+uby2dp4IFodnC0Kfoho6XhW8+uBxlldS5S1N0tWbBmfFE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 09:43:58AM +0100, Vlastimil Babka (SUSE) wrote:
> In order to deprecate the CONFIG_SLUB_TINY option, introduce an early
> boot param slab_tiny to control the value of slab_tiny_enabled.
> 
> As long as CONFIG_SLUB_TINY is still around and enabled, this boot param
> can also override it to be disabled. That could be also useful if we
> later add some auto-enabling conditions such as detecting the system has
> only a small amount of memory, or being a kdump kernel.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon

