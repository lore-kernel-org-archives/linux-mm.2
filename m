Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EACC2606D817
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 06:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=HbdJk/N7
Received: by kanga.kvack.org (Postfix)
	id 77B256B05B2; Sun,  8 Nov 2026 01:00:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 702D06B05B4; Sun,  8 Nov 2026 01:00:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57C796B05B5; Sun,  8 Nov 2026 01:00:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1F2336B05B2
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 01:00:26 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B4500A7FDC
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 06:00:25 +0000 (UTC)
X-FDA: 85410902010.30.A71687D
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by imf31.hostedemail.com (Postfix) with ESMTP id EF4EF20002
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 06:00:23 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="HbdJk/N7";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of 39g_wagsKCDURcdRjipdZeRXffXcV.TfdcZelo-ddbmRTb.fiX@flex--almasrymina.bounces.google.com designates 74.125.82.200 as permitted sender) smtp.mailfrom=39g_wagsKCDURcdRjipdZeRXffXcV.TfdcZelo-ddbmRTb.fiX@flex--almasrymina.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794117624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ls8Vsqz37bk9Lc/TUQk6BA8al47BcGIFX0n6D6YIHe4=;
	b=kAkKTVhSgPq+A9BP/R+QmnjsKyemruIW7XRBsBz91ggTaCTgMm0S7sw0fcBHH/nFc3gMoL
	K3Hp+Sq53S/sOmXJLTUXrtdIAlzAt87bsxQUGsJu7vu5PFAgDr+t5DQ/JdfhNAoKhFf+E+
	ZxUVjaW+SYgjqeRb0YRcVmkwxxS7aPo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794117624;
	b=e6SD0F+/SkA54sjNPANNAXZgjgQoYs/eFxdHpWetXfpV2cFsEA53I6CPt8FH10upz4B2zQ
	3FRbU1HLwftammSAwQn8xAXcXBe3Cy9dT8dW93qtzZGU0RKohPxJSo7GAyhNRsOnaOexsa
	2Qy5fKuUDkL64g+u0Q0ULVODApu6VZk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="HbdJk/N7";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of 39g_wagsKCDURcdRjipdZeRXffXcV.TfdcZelo-ddbmRTb.fiX@flex--almasrymina.bounces.google.com designates 74.125.82.200 as permitted sender) smtp.mailfrom=39g_wagsKCDURcdRjipdZeRXffXcV.TfdcZelo-ddbmRTb.fiX@flex--almasrymina.bounces.google.com
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-30bcb065bfdso584153eec.0
        for <linux-mm@kvack.org>; Sat, 07 Nov 2026 22:00:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794117623; x=1794722423; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ls8Vsqz37bk9Lc/TUQk6BA8al47BcGIFX0n6D6YIHe4=;
        b=HbdJk/N7T5JA6K9VDc9tr1CLQwyEHcIUpydtczLhpwUfIy/pLHi5qcruCuM5Q1XLqy
         6ZCzQLBpJFtcyUmmTmRdruBkvCh0FonRgF1+V7Mh0KOSlY9knfbb5wyeFwTB62HyejNb
         YrdrMtyoh2OEfWh2/k/eVES/fKNLQRRXpQBajM2ux3RXsLrrKsXOE7E+jz5Pwy9Yz4XE
         vCMY+GpqaLeSPA9n3UaRHA1YMOOkkW332+rNkNr3LYw6wt3pn5BMIRg31WTdHgiV2Rf3
         Q+ulfTabwInqPBxCLsMmlQvII71rGjjn572qwW3PeW4fwZ0GyRUk4YOpD9a8Nk5wQEze
         8bcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794117623; x=1794722423;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ls8Vsqz37bk9Lc/TUQk6BA8al47BcGIFX0n6D6YIHe4=;
        b=NlFGoMB1jnzqywlDnMBgb1cQcmLyRuuy9SiNS8/76PibSubJIEWwgQ/YM056REtPYs
         HKYQYVjmyZmbVPybCaTh3bSqa4gcekXqwhMC+qyZVX8eMXBBzJ3JyXaUntUy8T1kPTrb
         g885yM25GkgCoqDzbpLfvXQ9eUNATM39H0jcTJCQtdecPQiRgqu3LWnRUurhZssRviaz
         lfmetwRtZj+NUcef3aWChChUvfISGwmCHb2nfddoQC94mKxU2y9Wy6kfahoIro0ohNu7
         xdyJcjOx0vwVKyjdJnKOjEHLkva+O/Ih/K7HH0YN02vkh1dWWM5BGMUZQ0/YzUkWrHHZ
         VEvw==
X-Forwarded-Encrypted: i=1; AKwUvBzFA5jmid3ZBbtJhN+3z49hrM/smG7d+ElrVEuiX8BDfHla/1pmLnFozxWT9uSO2/8FRIj7+q9wSg==@kvack.org
X-Gm-Message-State: APuU4Z9sG1PRVO1WX5gccxN15BVcPc97ygMj5TWxfAUdZu6lHuHV0Duv
	rFIKdbUoVlrXZB5efWVNwOCWce4FsUn7zHrB5lX0NzoqPQnQ0asmhE0BZ0dZtCE0VAGYMh0JyT8
	Vv6fI90ZC1uoRNqU6D+bFKbFpiw==
X-Received: from dycmb13-n2.prod.google.com ([2002:a05:693c:20cd:20b0:36a:17c6:6824])
 (user=almasrymina job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:693c:6390:20b0:36c:9bc6:3ec with SMTP id 5a478bee46e88-37252f3042emr1787652eec.3.1794117622089;
 Sat, 07 Nov 2026 22:00:22 -0800 (PST)
Date: Sun,  8 Nov 2026 06:00:14 +0000
In-Reply-To: <20261108060016.2131509-1-almasrymina@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261108060016.2131509-1-almasrymina@google.com>
X-Mailer: git-send-email 2.56.0.455.g6c5a503b38-goog
Message-ID: <20261108060016.2131509-4-almasrymina@google.com>
Subject: [PATCH net-next v2 3/5] tcp: detach page_pool pages before mapping in tcp_zerocopy_receive()
From: Mina Almasry <almasrymina@google.com>
To: netdev@vger.kernel.org
Cc: Mina Almasry <almasrymina@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Neal Cardwell <ncardwell@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Pavel Begunkov <asml.silence@gmail.com>, 
	Bobby Eshleman <bobbyeshleman@meta.com>, Stanislav Fomichev <sdf@fomichev.me>, linux-kernel@vger.kernel.org, 
	Steffen Klassert <steffen.klassert@secunet.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Willem de Bruijn <willemb@google.com>, John Fastabend <john.fastabend@gmail.com>, 
	Sabrina Dubroca <sd@queasysnail.net>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowangio@gmail.com>, 
	"=?UTF-8?q?Eugenio=20P=C3=A9rez?=" <eperezma@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Johannes Berg <johannes@sipsolutions.net>, Byungchul Park <byungchul@sk.com>, Zi Yan <ziy@nvidia.com>, 
	virtualization@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-wireless@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Lorenzo Bianconi <lorenzo@kernel.org>, Wen Gu <guwen@linux.alibaba.com>, 
	Philo Lu <lulie@linux.alibaba.com>, Justin Chen <justin.chen@broadcom.com>, 
	Florian Fainelli <florian.fainelli@broadcom.com>, Vikas Gupta <vikas.gupta@broadcom.com>, 
	Michael Chan <michael.chan@broadcom.com>, Pavan Chebbi <pavan.chebbi@broadcom.com>, 
	Doug Berger <opendmb@gmail.com>, Nicolai Buchwitz <nb@tipi-net.de>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, Satish Kharat <satishkh@cisco.com>, 
	Wei Fang <wei.fang@nxp.com>, Frank Li <frank.li@nxp.com>, Shenwei Wang <shenwei.wang@nxp.com>, 
	Joshua Washington <joshwash@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>, 
	Jijie Shao <shaojijie@huawei.com>, Jian Shen <shenjian15@huawei.com>, 
	Fan Gong <gongfan1@huawei.com>, Tony Nguyen <anthony.l.nguyen@intel.com>, 
	Przemek Kitszel <przemyslaw.kitszel@intel.com>, Marcin Wojtas <marcin.s.wojtas@gmail.com>, 
	Russell King <linux@armlinux.org.uk>, Sunil Goutham <sgoutham@marvell.com>, 
	Geetha sowjanya <gakula@marvell.com>, Ratheesh Kannoth <rkannoth@marvell.com>, 
	Subbaraya Sundeep <sbhatta@marvell.com>, Bharat Bhushan <bbhushan2@marvell.com>, 
	Felix Fietkau <nbd@nbd.name>, Matthias Brugger <matthias.bgg@gmail.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, Tariq Toukan <tariqt@nvidia.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>, 
	Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>, 
	Horatiu Vultur <horatiu.vultur@microchip.com>, UNGLinuxDriver@microchip.com, 
	Daniel Machon <daniel.machon@microchip.com>, Steen Hegelund <Steen.Hegelund@microchip.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Yibo Dong <dong100@mucse.com>, 
	Brett Creeley <brett.creeley@amd.com>, Justin Lai <justinlai0215@realtek.com>, 
	Larry Chiu <larry.chiu@realtek.com>, 
	"=?UTF-8?q?Niklas=20S=C3=B6derlund?=" <niklas.soderlund@ragnatech.se>, Paul Barker <paul@pbarker.dev>, 
	Masahisa Kojima <kojima.masahisa@socionext.com>, 
	Maxime Chevallier <maxime.chevallier@bootlin.com>, Maxime Coquelin <mcoquelin.stm32@gmail.com>, 
	Alexandre Torgue <alexandre.torgue@foss.st.com>, FUJITA Tomonori <fujita.tomonori@gmail.com>, 
	Siddharth Vadapalli <s-vadapalli@ti.com>, Roger Quadros <rogerq@kernel.org>, 
	MD Danish Anwar <danishanwar@ti.com>, Jiawen Wu <jiawenwu@trustnetic.com>, 
	Mengyuan Lou <mengyuanlou@net-swift.com>, Ronak Doshi <ronak.doshi@broadcom.com>, 
	Ryder Lee <ryder.lee@mediatek.com>, Shayne Chen <shayne.chen@mediatek.com>, 
	Sean Wang <sean.wang@mediatek.com>, Juergen Gross <jgross@suse.com>, 
	Stefano Stabellini <sstabellini@kernel.org>, 
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>, Jordan Rhee <jordanrhee@google.com>, 
	Ankit Garg <nktgrg@google.com>, Tim Hostetler <thostet@google.com>, 
	Eric Joyner <eric.joyner@amd.com>, Prabu Thayalan <prabu.ponrajthayalan@amd.com>, 
	"Nikhil P. Rao" <nikhil.rao@amd.com>, Chintan Vankar <c-vankar@ti.com>, 
	Nora Schiffer <nora.schiffer@ew.tq-group.com>, Alexander Sverdlin <alex@sverdlin.org>, 
	Kevin Hao <haokexin@gmail.com>, Karl Mehltretter <kmehltretter@gmail.com>, 
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>, Meghana Malladi <m-malladi@ti.com>, 
	Jacob Keller <jacob.e.keller@intel.com>, StanleyYP Wang <StanleyYP.Wang@mediatek.com>, 
	linux-doc@vger.kernel.org, imx@lists.linux.dev, linux-rdma@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, linux-renesas-soc@vger.kernel.org, 
	linux-omap@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: wf5nek66oo5rmpxz6f4fywdwtkh6qbyc
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EF4EF20002
X-HE-Tag: 1794117623-381504
X-HE-Meta: U2FsdGVkX19xyOIY0uHBna4pwhvFJzx9PWWq6UvbUioQQKrsQ/8JiXOfkvXqozycHYW6EfJGeRmKhm58YUIgQfHaDPlG5rrr0W8y3KT4QZGcFq0QmA6WZKYLxkpjJK8kIN7AcBDvXXGIPPXPvEdIl1pqgd/35V94tzUPE7g+htH1c2N/k5j6XGVtDI6QVoelRZQg/NZBug/1WTtbBsVFdlOXeyv68lON7FBpE1nL6oLfXHhoOZdgrLmgXSLqr3Rk7Ydu+ZR5vqKiXnj0sEXSnBdvEVPvC9Uhsu4pMl3phjR0wVbgQ8uQrguzbYhK+5asDQjwbcLrK+pJkevd/Ix5w/uiZyqGT8Xsg3g2J8tjcOToisNQqQkmBOZ6Iq0GWiHxieYna+wTo6YqtYehaOo8/pJH2vI8Sxrf7cCg4WIhKWGz1EtJ86cWQO18p70gcJvpl64e+gLtbA8pRajD8iE6nztX0mQoLvm7joWSQM65Q5XwDQwVS6DhlYRgGAUC7m4+xjPhYpeOTryDTekXUaISxW1tbBcHXYHu0arrJc/UPCLGivoyuuvznwhD0vxkeEMRRVXJCQwQwRSXrfLIWdRiUuW8FL91SbWAjLKTjMck3robgsQ9IeBXcPuMzeXpCQjeSguj7mZARVSt9exaNPKdX6mn0ClM0t8fyqld4aKZEEK2ybDZ2N6YO6C1LQ8KJt7scCJmfdN6AFNL30OXB6mNfbTSvy/Ta8G1UceSBSRLXQ6ohJXnlaZLDyQMF34ixnBxE2DtJlWP3NhxA/zT7BkD7mudmwXuSVq/TykY84SANEhslLTwYktjeRILVf/JcXU6vF0/ngAIWz9xdG4fmkWk6BIcfSY9V8EvneIiH5wlt+5zc1ms/urvmDleizCPk25nEv908FVxmE0iidXpd8FheioLn0LKotVHFNrHKQJtlz+55mv4YZGcK131fwuWyJB317JHrzzRH+Kc4epO8WS
 UHQP1wDv
 /TsdjPgCfSzQ69SzRmm7lGZ8IVauO/eGmeizI6Y/vU6vNGd8eXK9E5sUaIRnI8vaNpj700VqkB3WxCEwBxO7ROtVCcw/GKCDDFFSDp9fna+lb24f9pFFnIx4gD34POssGibBCwvrG8++76PiqHowtvtS8U/70YKHZ7NhPUSsmSeYuo+Vf4fJWm5jJtGqo6CLMOHiD0cNIHpsbEG2lJfvAXaMmF3MVRqziKejePLUX0UXnPh23aIjULnmxtADMUkBIcYNcoJ4AwvRoJ1uyN2EaGpEH0cN+3x2M3EKZnUDr2HfT8/yy2WKiCjBtmHlS4/zo5PS3dcRTOunWGd0lyh7Ap4b4wDqZFZVrnou2/rBh4DKgbV9keQ/4qxv7qiNPgdvSja96wv2uzQaYjGz3ns9Wo4eZtSu44vsi3//VlHjS1QDfa8NA0Q8qbLuAaWx/wkHthxedLrjnlo21pUPvRhwjqqlbu0kDXy8uBxgKSBeFZ8rEUy8HVGdLFpCk8Fh74AVru4G3/GXyNrMGfvCc0miGgdIqjNtY75vl3dB3Gu+D7izZn6VjZuuyQqVfsAsMHkWQdJeX8dSbjdQYbwcBZiYtAJ/orlgFTmtw0tHSQakxMzX6J8NpqbcrIzXaVzA51Gl8K8xxy/qzvGfTLWxbzfwWaCUGjn4mBc+zIn8HgeEGHSgX4ABmgOk2hOMBWOFJYZ5zt5kU9PupmqavgD78eRKw/tPDXFGqSRDwBTAHlAJMbWDBEdMqHaJglF6fNQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Once tcp_zerocopy_receive() maps an order-0 RX fragment page into a
userspace VMA via vm_insert_pages(), vm_insert_pages() increments
page->_refcount, which prevents the page from being recycled back into
its page_pool when the RX SKB is freed. However, while the RX SKB still
holds its fragment reference, the page remains marked as a page_pool
page (page_pool_page_is_pp(page) == true) inside the userspace VMA, so
subsequent GUP callers such as sendmsg(MSG_ZEROCOPY) or vmsplice() can
encounter a page_pool page while holding only a raw struct page
reference.

Establish the invariant that pp_ref_count is only incremented by callers
that already hold an active pp_ref_count (>= 1) on that netmem, and a
raw page_ref_count is never converted into a pp_ref_count:
- In can_map_frag(), require !skb_cloned(skb), page_pool_ref_count == 1,
  and page_ref_count == 1 for page_pool pages so the fragment being
  mapped holds the sole reference to the page; cloned SKBs or page_pool
  pages with additional references (including drivers holding an
  undrained fragment bias) fall back to copying.
- In tcp_zerocopy_receive(), convert the fragment's sole pp_ref_count
  into a regular page reference and detach the page from its page_pool
  via get_page(page) + napi_pp_put_page(page_to_netmem(page)) before
  queueing the page for vm_insert_pages(). If vm_insert_pages()
  subsequently fails, the detached page remains referenced by the RX SKB
  via its regular page reference and is freed back to the page allocator
  when the SKB is consumed.

Signed-off-by: Mina Almasry <almasrymina@google.com>
---
 include/net/page_pool/helpers.h |  5 ++++
 net/core/datagram.c             |  2 ++
 net/ipv4/tcp.c                  | 44 ++++++++++++++++++++++++++++-----
 3 files changed, 45 insertions(+), 6 deletions(-)

diff --git a/include/net/page_pool/helpers.h b/include/net/page_pool/helpers.h
index 28635ce9454e8..c814ce95282eb 100644
--- a/include/net/page_pool/helpers.h
+++ b/include/net/page_pool/helpers.h
@@ -242,6 +242,11 @@ page_pool_get_dma_dir(const struct page_pool *pool)
 	return pool->p.dma_dir;
 }
 
+static inline long page_pool_ref_count(netmem_ref netmem)
+{
+	return atomic_long_read(netmem_get_pp_ref_count_ref(netmem));
+}
+
 static inline void page_pool_fragment_netmem(netmem_ref netmem, long nr)
 {
 	atomic_long_set(netmem_get_pp_ref_count_ref(netmem), nr);
diff --git a/net/core/datagram.c b/net/core/datagram.c
index ecc30a6f83023..808eda4f7efb5 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -34,6 +34,7 @@
  *
  */
 
+#include <kunit/visibility.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
@@ -702,6 +703,7 @@ int zerocopy_fill_skb_from_iter(struct sk_buff *skb,
 	}
 	return 0;
 }
+EXPORT_SYMBOL_IF_KUNIT(zerocopy_fill_skb_from_iter);
 
 static int
 zerocopy_fill_skb_from_devmem(struct sk_buff *skb, struct iov_iter *from,
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index b9de7c302ba83..a984e7e93e4c9 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -286,6 +286,7 @@
 #include <asm/ioctls.h>
 #include <net/busy_poll.h>
 #include <net/hotdata.h>
+#include <net/page_pool/helpers.h>
 #include <trace/events/tcp.h>
 #include <net/rps.h>
 
@@ -1921,7 +1922,7 @@ static skb_frag_t *skb_advance_to_frag(struct sk_buff *skb, u32 offset_skb,
 	return frag;
 }
 
-static bool can_map_frag(const skb_frag_t *frag)
+static bool can_map_frag(const struct sk_buff *skb, const skb_frag_t *frag)
 {
 	struct page *page;
 
@@ -1935,18 +1936,32 @@ static bool can_map_frag(const skb_frag_t *frag)
 	if (PageCompound(page) || page->mapping)
 		return false;
 
+	/* Before mapping a page_pool page into userspace,
+	 * tcp_zerocopy_receive() converts this fragment's pp_ref_count into a
+	 * regular page reference and detaches the page from its page_pool via
+	 * napi_pp_put_page(). Require this skb_frag_t to hold the sole
+	 * reference to the page so no other fragment or SKB clone expects
+	 * pp_ref_count on it after detachment.
+	 */
+	if (page_pool_page_is_pp(page) &&
+	    (skb_cloned(skb) ||
+	     page_pool_ref_count(page_to_netmem(page)) != 1 ||
+	     page_ref_count(page) != 1))
+		return false;
+
 	return true;
 }
 
-static int find_next_mappable_frag(const skb_frag_t *frag,
+static int find_next_mappable_frag(const struct sk_buff *skb,
+				   const skb_frag_t *frag,
 				   int remaining_in_skb)
 {
 	int offset = 0;
 
-	if (likely(can_map_frag(frag)))
+	if (likely(can_map_frag(skb, frag)))
 		return 0;
 
-	while (offset < remaining_in_skb && !can_map_frag(frag)) {
+	while (offset < remaining_in_skb && !can_map_frag(skb, frag)) {
 		offset += skb_frag_size(frag);
 		++frag;
 	}
@@ -1986,7 +2001,8 @@ static void tcp_zerocopy_set_hint_for_skb(struct sock *sk,
 	 * mappable_offset: Bytes till next mappable frag, *not* counting bytes
 	 * in partial_frag_remainder.
 	 */
-	mappable_offset = find_next_mappable_frag(frag, zc->recv_skip_hint);
+	mappable_offset = find_next_mappable_frag(skb, frag,
+						  zc->recv_skip_hint);
 	zc->recv_skip_hint = mappable_offset + partial_frag_remainder;
 }
 
@@ -2290,7 +2306,7 @@ static int tcp_zerocopy_receive(struct sock *sk,
 				break;
 		}
 
-		mappable_offset = find_next_mappable_frag(frags,
+		mappable_offset = find_next_mappable_frag(skb, frags,
 							  zc->recv_skip_hint);
 		if (mappable_offset) {
 			zc->recv_skip_hint = mappable_offset;
@@ -2300,6 +2316,22 @@ static int tcp_zerocopy_receive(struct sock *sk,
 		if (WARN_ON_ONCE(!page))
 			break;
 
+		/* Convert this fragment's sole pp_ref_count into a regular
+		 * page reference and detach the page from its page_pool before
+		 * mapping it into userspace. Once vm_insert_pages() elevates
+		 * page_ref_count the page cannot be recycled into the
+		 * page_pool anyway (and if vm_insert_pages() fails, the
+		 * detached page is freed to the page allocator when the skb is
+		 * consumed); detaching it up front ensures that a page_pool
+		 * page is never mapped into a userspace VMA (where GUP callers
+		 * such as MSG_ZEROCOPY or vmsplice() would otherwise observe a
+		 * page_pool page while holding only a raw page_ref_count).
+		 */
+		if (page_pool_page_is_pp(page)) {
+			get_page(page);
+			napi_pp_put_page(page_to_netmem(page));
+		}
+
 		prefetchw(page);
 		pages[pages_to_map++] = page;
 		length += PAGE_SIZE;
-- 
2.56.0.455.g6c5a503b38-goog


