Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78A29C531C9
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 15:38:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20DD56B0088; Sat, 25 Jul 2026 11:38:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BEAB6B008A; Sat, 25 Jul 2026 11:38:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 087366B008C; Sat, 25 Jul 2026 11:38:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C36D56B0088
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 11:38:16 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3519D1A0391
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 15:38:16 +0000 (UTC)
X-FDA: 85027705392.07.B11D01A
Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.169])
	by imf20.hostedemail.com (Postfix) with ESMTP id 37B1B1C0007
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 15:38:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b="H/SFRgmp";
	spf=pass (imf20.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.169 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784993894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iaLgv2BDveiB9cTDQA1hlKsSjdSyePkmq764Gt+8i9o=;
	b=eATp6MoxJq5BcFjdFJux9+rbvrYdjmfmy1+GQyKlen7qieIkrgYLkdxfkp+WGLAquaoa+i
	wITchrrn9avLyAFWztdqJyvBbijAumtOgQbD8SQZd3BfNBmxpdpOrQ5iC1hEw8NTAAu31N
	oNe7uOmc2fnAMj7MESjklPCnEC/HF+A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784993894;
	b=A1YzVETDWga2mNhZPYh8sxsgY6oXR00f7mUu0z7Nbo8ayi+QGOgAl4ZwgASVNRUDmDCVvF
	YYQAcgIkDl36DTJJ91wdtnyBqKe2t5foA67LF+XAnyiI5+WSxqInBeCnBIiItSzWzq8ZA+
	hcVi4M0XY24IqkCvsWqXXfn5yICJO5Y=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b="H/SFRgmp";
	spf=pass (imf20.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.169 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
X-KPN-MessageId: d7a27b54-883e-11f1-a055-005056abad63
Received: from smtp.kpnmail.nl (unknown [10.31.155.39])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id d7a27b54-883e-11f1-a055-005056abad63;
	Sat, 25 Jul 2026 17:38:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=content-type:mime-version:message-id:subject:to:from:date;
	bh=iaLgv2BDveiB9cTDQA1hlKsSjdSyePkmq764Gt+8i9o=;
	b=H/SFRgmp/wkyL5Osc/IokvsMfiC8/rfKn9PbyNR+v7iLQCH2BNSZHUR63zqNEgUowjbqlomKeUXxT
	 9J7tkQhp+AclzIaonD4HV1UUVKFTvqn6FxBMMouLlf1j3QixvMNReC9+iAkXQAT88rbXSNjBojvw6b
	 NrOSvylC8oMqrfdCl6t08wcmXD1jEgVMOyxAUfDpbhcOjJZawSB9jkesF5rQgIqn9FOBgcZxuqYtkp
	 do/64F9H5gVRqEn0X1mQWjNwkCyFaF9c1cHDGvuz6Z/oGtnGhL4hZGwZzJf9f8DrH4GnQQ0ZwpXUjq
	 13+XzNClMDk5K2zYy88rPCz+V8fowbw==
X-KPN-MID: 33|Ptxp6Zs7/h+NuZsak3+OeSQCCNiUSPIwGF8fI59RuPvMf250nskzpotnsi7gd+d
 zwUAKpmoPLPYm6wFG0PDK0gFYrnPJH0U9DyW60/nXyfw=
X-KPN-VerifiedSender: Yes
X-CMASSUN: 33|skO+pUPqv+vNG2cXkRl4mzbJxeDliO5zMiFxiIVeOt6yK0QELl4jSk1ejY1LYBU
 uuDxndJokqUgIr24lu0jSng==
X-Originating-IP: 85.144.169.142
Received: from localhost (142-169-144-85.ftth.glasoperator.nl [85.144.169.142])
	by smtp.xs4all.nl (Halon) with ESMTPSA
	id d6ece956-883e-11f1-a8b6-005056ab7447;
	Sat, 25 Jul 2026 17:38:11 +0200 (CEST)
Date: Sat, 25 Jul 2026 17:38:09 +0200
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, 
	Farid Zakaria <farid.m.zakaria@gmail.com>, jannh@google.com
Subject: Re: [PATCH v3 09/24] binfmt_misc: rename Node to struct
 binfmt_misc_entry
Message-ID: <amTYWb9X1B75lIdX@lt-jori.localdomain>
References: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
 <20260710-work-binfmt_misc-locking-v3-9-a162f7cb58d6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-work-binfmt_misc-locking-v3-9-a162f7cb58d6@kernel.org>
X-Stat-Signature: k7yf3nna9e3d16r19doanxytknazaz7o
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 37B1B1C0007
X-HE-Tag: 1784993894-655913
X-HE-Meta: U2FsdGVkX1+QnwBmILRqOD2+JEowG/00vKuhMXY8M4ed7VPE1aVSO/atgF9aF4B2poSDNDWSdLLsjGeeZMKYv+Hd+r8MGUJKtx+A9Ahg2rJQUdQZq6LbRUB8bWphrKKBmIidDg6mti/wfarjopn3USPVR/zidPBcUERzmhDNpGXReLHfIEpu0F7zGXCarsjaaN9Ee9azjXt5CQRjQvSU6cSk/I+L/OQl4JiVpnol/ilpw2JLx+Wd2uvTM5pF/FlaUm6YZqCQLoEwzqY6C5br7CM8QEIGuE1K8J8cXRrFT0lFzp1Q+4461KEDBQi13bsMtTUgndxgH88UkkYiVAaT+ej2CqitO9fRB8EWw+siVX2iRtTg6NoREElO2ORcpVyf4UMPX8aZ/I2wCROeczsdwdp8a6D4P9/9s4SIHgmkN87S3a1WEqzQG+YxxKZp5dNYcf3y5XmxqcuCbfZX2APiyA78PL8GFO/JcbTyw+sLVom2ZL8chxuw1kveJMBhV7VYQ2vIcm9HFVYdECPZaxnV4E9D+TnaPfgerxjPbjrUXIKnE2o5gdw6s5pqKpm6Gd4XbzqlZ/t1Wa4dQ6LtnkpGGL3OVu2diY/TJM+ZhMJDKbb/XbsEAyzDV0i81bUiFMCLjz+yy8yz4DV7tjKEsN2d4NijNAvdzKJyTJnI/zWMkXQElLBXopTTmlUiH+UPWhyvQVkOPA46WNTd0myKB952I9V2xWXMINffSauakoXG9IiPbIqpqJbASqJsn/1rDtGiF+QhKiv5yjvyECwZIlIzdOUYu5IFT4j+gTJqT76MyAavCQrCxxg/OdDhfyPQ/ErjGwF0sua77bTLjJPv+M7WkL65BNPYGNyV7NW8DrlErqewBthYj8qYRaUphovd/N40/5+S6S7VyJ6uvO/V6ptvRaqZeKzOFQG8IlVwnpL1fK8qT0nkxC1HXC0ezCZdm2GS13AbVrpe4gKI2vhWWkg
 fgjlibgi
 RqNx/Ovm23X+EbU+oh7J5I45LOaJYBrMzaZ7Km/goVa93U+graYAl6YNLxvomtgAwG8gk9+uN7TtRoCEnsotvLuoPHtJ8rmMFJfZGRa9LILtUPeXu+G8lhRdLu5Ap8Ngr4+Wsuz934WCCV8yJN0eI721mpPgcVnp5zHVFsJ7/8wPv6n3UYl1G1aL9mv+/K8S8BxjIUKB0cg8EQnjnB0U004Q278ilYbU3A3Gb3hVOGZptEssZVYHnaNr87e+KzsqqnOzXeMwkyOWdBxrwrPVyhSZyDVLVB7Ri1LF+bspUGw1upQu+Do4qb5fYXLql39WQBCrw+5kYj9Syv/8IVFRKBxXAY7Qf3dicz7ORY99EiB2+zibAPcyjiqEtJoMMuLN6UAi39SgKJScT09tEeftQPPSZ6fMoqSyptKh8ZewiUaH7p6SWjg3dWqv/F6g8A6Vp00ufZRO+rGRU3mvbb2PAmjW+bLE8lKbXYpcbAXRvNYzch8gFwYNVpy9mdao4AFmYcmYNkkNfF5ElyPzX2ZOFX9JgHknID5fYUvQH7yPaWx/SxyNPhKyKWIsKmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 11:33:10AM +0200, Christian Brauner wrote:
> The CamelCase Node typedef is a 1997 leftover and hides that this is
> a plain struct. Call it what it is: struct binfmt_misc_entry, matching
> struct binfmt_misc that it hangs off of and the entry bit and flag
> enums. Drop the typedef, switch the size computations in
> create_entry() to sizeof(*e) and adjust the comments that still
> referred to the old name.
> 
> No functional change.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/binfmt_misc.c | 60 +++++++++++++++++++++++++++++---------------------------
>  1 file changed, 31 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> index 98ad1383ba6b..9be57f387524 100644
> --- a/fs/binfmt_misc.c
> +++ b/fs/binfmt_misc.c
> @@ -56,7 +56,7 @@ enum binfmt_misc_entry_flags {
>  	MISC_FMT_OPEN_FILE	= (1U << 28),
>  };
>  
> -typedef struct {
> +struct binfmt_misc_entry {
>  	struct hlist_node node;
>  	unsigned long flags;		/* type, status, etc. */
>  	int offset;			/* offset of magic */
> @@ -69,7 +69,7 @@ typedef struct {
>  	struct file *interp_file;
>  	refcount_t users;		/* sync removal with load_misc_binary() */
>  	struct rcu_head rcu;
> -} Node;
> +};
>  
>  static struct file_system_type bm_fs_type;
>  
> @@ -84,7 +84,7 @@ static struct file_system_type bm_fs_type;
>   *  - interp: ~50 bytes
>   *  - flags:  5 bytes
>   * Round that up a bit, and then back off to hold the internal data
> - * (like struct Node).
> + * (like struct binfmt_misc_entry).
>   */
>  #define MAX_REGISTER_LENGTH 1920
>  
> @@ -100,11 +100,11 @@ static struct file_system_type bm_fs_type;
>   *
>   * Return: binary type list entry on success, NULL on failure
>   */
> -static Node *search_binfmt_handler(struct binfmt_misc *misc,
> -				   struct linux_binprm *bprm)
> +static struct binfmt_misc_entry *
> +search_binfmt_handler(struct binfmt_misc *misc, struct linux_binprm *bprm)
>  {
>  	char *p = strrchr(bprm->interp, '.');
> -	Node *e;
> +	struct binfmt_misc_entry *e;
>  
>  	/* Walk all the registered handlers. */
>  	hlist_for_each_entry_rcu(e, &misc->entries, node) {
> @@ -153,10 +153,10 @@ static Node *search_binfmt_handler(struct binfmt_misc *misc,
>   *
>   * Return: binary type list entry on success, NULL on failure
>   */
> -static Node *get_binfmt_handler(struct binfmt_misc *misc,
> -				struct linux_binprm *bprm)
> +static struct binfmt_misc_entry *get_binfmt_handler(struct binfmt_misc *misc,
> +						    struct linux_binprm *bprm)
>  {
> -	Node *e;
> +	struct binfmt_misc_entry *e;
>  
>  	guard(rcu)();
>  	do {
> @@ -166,14 +166,14 @@ static Node *get_binfmt_handler(struct binfmt_misc *misc,
>  }
>  
>  /**
> - * put_binfmt_handler - put binary handler node
> - * @e: node to put
> + * put_binfmt_handler - put binary handler entry
> + * @e: entry to put
>   *
> - * Free node syncing with load_misc_binary() and defer final free to
> + * Free entry syncing with load_misc_binary() and defer final free to
>   * load_misc_binary() in case it is using the binary type handler we were
>   * requested to remove.
>   */
> -static void put_binfmt_handler(Node *e)
> +static void put_binfmt_handler(struct binfmt_misc_entry *e)
>  {
>  	if (refcount_dec_and_test(&e->users)) {
>  		if (e->flags & MISC_FMT_OPEN_FILE) {
> @@ -219,7 +219,7 @@ static struct binfmt_misc *load_binfmt_misc(void)
>   */
>  static int load_misc_binary(struct linux_binprm *bprm)
>  {
> -	Node *fmt;
> +	struct binfmt_misc_entry *fmt;
>  	struct file *interp_file = NULL;
>  	int retval = -ENOEXEC;
>  	struct binfmt_misc *misc;
> @@ -290,7 +290,7 @@ static int load_misc_binary(struct linux_binprm *bprm)
>  ret:
>  
>  	/*
> -	 * If we actually put the node here all concurrent calls to
> +	 * If we actually put the entry here all concurrent calls to
>  	 * load_misc_binary() will have finished. We also know
>  	 * that for the refcount to be zero someone must have concurently
>  	 * removed the binary type handler from the list and it's our job to
> @@ -326,7 +326,7 @@ static char *scanarg(char *s, char del)
>  	return s;
>  }
>  
> -static char *check_special_flags(char *sfs, Node *e)
> +static char *check_special_flags(char *sfs, struct binfmt_misc_entry *e)
>  {
>  	char *p = sfs;
>  	int cont = 1;
> @@ -370,9 +370,10 @@ static char *check_special_flags(char *sfs, Node *e)
>   * ':name:type:offset:magic:mask:interpreter:flags'
>   * where the ':' is the IFS, that can be chosen with the first char
>   */
> -static Node *create_entry(const char __user *buffer, size_t count)
> +static struct binfmt_misc_entry *create_entry(const char __user *buffer,
> +					      size_t count)
>  {
> -	Node *e;
> +	struct binfmt_misc_entry *e;
>  	int memsize, err;
>  	char *buf, *p;
>  	char del;
> @@ -385,14 +386,14 @@ static Node *create_entry(const char __user *buffer, size_t count)
>  		goto out;
>  
>  	err = -ENOMEM;
> -	memsize = sizeof(Node) + count + 8;
> +	memsize = sizeof(*e) + count + 8;
>  	e = kmalloc(memsize, GFP_KERNEL_ACCOUNT);
>  	if (!e)
>  		goto out;
>  
> -	p = buf = (char *)e + sizeof(Node);
> +	p = buf = (char *)e + sizeof(*e);
>  
> -	memset(e, 0, sizeof(Node));
> +	memset(e, 0, sizeof(*e));
>  	if (copy_from_user(buf, buffer, count))
>  		goto efault;
>  
> @@ -602,7 +603,7 @@ static int parse_command(const char __user *buffer, size_t count)
>  
>  /* generic stuff */
>  
> -static void entry_status(Node *e, char *page)
> +static void entry_status(struct binfmt_misc_entry *e, char *page)
>  {
>  	char *dp = page;
>  	const char *status = "disabled";
> @@ -686,7 +687,7 @@ static struct binfmt_misc *i_binfmt_misc(struct inode *inode)
>  */
>  static void bm_evict_inode(struct inode *inode)
>  {
> -	Node *e = inode->i_private;
> +	struct binfmt_misc_entry *e = inode->i_private;
>  
>  	clear_inode(inode);
>  
> @@ -714,7 +715,8 @@ static void bm_evict_inode(struct inode *inode)
>   * to use writes to files in order to delete binary type handlers. But it has
>   * worked for so long that it's not a pressing issue.
>   */
> -static void remove_binfmt_handler(struct binfmt_misc *misc, Node *e)
> +static void remove_binfmt_handler(struct binfmt_misc *misc,
> +				  struct binfmt_misc_entry *e)
>  {
>  	spin_lock(&misc->entries_lock);
>  	hlist_del_init_rcu(&e->node);
> @@ -727,7 +729,7 @@ static void remove_binfmt_handler(struct binfmt_misc *misc, Node *e)
>  static ssize_t
>  bm_entry_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
>  {
> -	Node *e = file_inode(file)->i_private;
> +	struct binfmt_misc_entry *e = file_inode(file)->i_private;
>  	ssize_t res;
>  	char *page;
>  
> @@ -747,7 +749,7 @@ static ssize_t bm_entry_write(struct file *file, const char __user *buffer,
>  				size_t count, loff_t *ppos)
>  {
>  	struct inode *inode = file_inode(file);
> -	Node *e = inode->i_private;
> +	struct binfmt_misc_entry *e = inode->i_private;
>  	int res = parse_command(buffer, count);
>  
>  	switch (res) {
> @@ -796,7 +798,7 @@ static const struct file_operations bm_entry_operations = {
>  /* /register */
>  
>  /* add to filesystem */
> -static int add_entry(Node *e, struct super_block *sb)
> +static int add_entry(struct binfmt_misc_entry *e, struct super_block *sb)
>  {
>  	struct dentry *dentry = simple_start_creating(sb->s_root, e->name);
>  	struct inode *inode;
> @@ -828,7 +830,7 @@ static int add_entry(Node *e, struct super_block *sb)
>  static ssize_t bm_register_write(struct file *file, const char __user *buffer,
>  			       size_t count, loff_t *ppos)
>  {
> -	Node *e;
> +	struct binfmt_misc_entry *e;
>  	struct super_block *sb = file_inode(file)->i_sb;
>  	int err = 0;
>  	struct file *f = NULL;
> @@ -894,7 +896,7 @@ static ssize_t bm_status_write(struct file *file, const char __user *buffer,
>  	int res = parse_command(buffer, count);
>  	struct hlist_node *next;
>  	struct inode *inode;
> -	Node *e;
> +	struct binfmt_misc_entry *e;
>  
>  	misc = i_binfmt_misc(file_inode(file));
>  	switch (res) {
> 
> -- 
> 2.53.0
> 

Reviewed-by: Jori Koolstra <jkoolstra@xs4all.nl>

